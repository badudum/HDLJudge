library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

entity tb is
end entity;

architecture sim of tb is
    signal clk, rst, start, cmp : std_logic := '0';
    signal vin          : real := 0.0;
    signal dac, result  : std_logic_vector(7 downto 0);
    signal done         : std_logic;
    signal tb_done      : boolean := false;
begin
    dut : entity work.sar_ctrl port map (clk => clk, rst => rst, start => start, cmp => cmp,
                                         dac => dac, done => done, result => result);

    clk <= not clk after 5 ns when not tb_done;

    -- analog model: ideal 8-bit DAC (VREF = 1.0) + comparator
    cmp <= '0' when is_x(dac) else
           '1' when vin >= real(to_integer(unsigned(dac))) / 256.0 else '0';

    process
        variable errors : natural;
        variable detail : line;
        variable s1, s2 : positive := 35;
        variable r      : real;

        function gold(v : real) return natural is
            variable x : real;
        begin
            x := floor(v * 256.0);
            if x < 0.0 then return 0; elsif x > 255.0 then return 255; else return integer(x); end if;
        end function;

        procedure start_test is
        begin
            errors := 0;
            deallocate(detail);
            detail := new string'("");
        end procedure;

        procedure end_test(name : string) is
        begin
            if errors = 0 then
                report "PASS: " & name;
            else
                report "FAIL: " & name & " -- " & detail.all & " (" & integer'image(errors) & " mismatches)";
            end if;
        end procedure;

        procedure fail(msg : string) is
        begin
            if errors = 0 then
                deallocate(detail);
                detail := new string'(msg);
            end if;
            errors := errors + 1;
        end procedure;

        procedure convert(v : real; inject : boolean) is
            variable cycles : natural;
            variable want   : std_logic_vector(7 downto 0);
        begin
            want := std_logic_vector(to_unsigned(gold(v), 8));
            wait until falling_edge(clk);
            vin <= v; start <= '1';
            wait until falling_edge(clk);
            start <= '0';
            cycles := 1;
            if inject and done /= '1' then
                start <= '1';
                wait until falling_edge(clk);
                start <= '0';
                cycles := cycles + 1;
            end if;
            while done /= '1' and cycles < 40 loop
                wait until falling_edge(clk);
                cycles := cycles + 1;
            end loop;
            if done /= '1' then
                fail("vin=" & real'image(v) & ": no done pulse within 40 cycles");
            else
                if result /= want then
                    fail("vin=" & real'image(v) & ": expected result=" & integer'image(gold(v)) &
                         ", got x" & to_hstring(result));
                end if;
                wait until falling_edge(clk);
                if done /= '0' then
                    fail("vin=" & real'image(v) & ": done must be a one-cycle pulse");
                end if;
                if result /= want then
                    fail("vin=" & real'image(v) & ": result must hold after done");
                end if;
            end if;
        end procedure;
    begin
        rst <= '1';
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        rst <= '0';

        start_test;
        convert(0.5, false); convert(0.0, false); convert(0.99609375, false); convert(0.25, false); convert(0.75, false);
        end_test("mid-scale and full-scale");

        start_test;
        convert(-0.3, false); convert(1.3, false); convert(1.0, false);
        end_test("clamps below 0 and above VREF");

        start_test;
        convert(0.3, true);
        end_test("start ignored during a conversion");

        start_test;
        for i in 0 to 511 loop
            convert(real(i) / 512.0, false);
        end loop;
        end_test("every code, on and between thresholds (512 conversions)");

        start_test;
        for i in 1 to 200 loop
            uniform(s1, s2, r);
            convert(r * 1.1 - 0.05, false);
        end loop;
        end_test("200 random input voltages");

        report "TB_DONE";
        tb_done <= true;
        std.env.finish;
    end process;
end architecture;
