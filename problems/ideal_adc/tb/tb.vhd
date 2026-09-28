library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

entity tb is
end entity;

architecture sim of tb is
    signal clk   : std_logic := '0';
    signal vin   : real := 0.0;
    signal code1, code2 : std_logic_vector(7 downto 0);
    signal done  : boolean := false;
begin
    dut1 : entity work.adc8 port map (clk => clk, vin => vin, code => code1);
    dut2 : entity work.adc8 generic map (VREF => 2.0) port map (clk => clk, vin => vin, code => code2);

    clk <= not clk after 5 ns when not done;

    process
        variable m1, m2 : natural := 0;
        variable errors : natural;
        variable detail : line;

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

        function quant(v, vref : real) return natural is
            variable x : real;
        begin
            x := floor(v / vref * 256.0);
            if x < 0.0 then return 0;
            elsif x > 255.0 then return 255;
            else return integer(x);
            end if;
        end function;

        procedure check is
        begin
            if code1 /= std_logic_vector(to_unsigned(m1, 8)) or code2 /= std_logic_vector(to_unsigned(m2, 8)) then
                if errors = 0 then
                    deallocate(detail);
                    detail := new string'("at t=" & time'image(now) & ": expected code=" & integer'image(m1) &
                        " (VREF=1) / " & integer'image(m2) & " (VREF=2), got x" & to_hstring(code1) &
                        " / x" & to_hstring(code2));
                end if;
                errors := errors + 1;
            end if;
        end procedure;

        procedure sample(v : real) is
        begin
            vin <= v;
            wait until falling_edge(clk);
            m1 := quant(v, 1.0);
            m2 := quant(v, 2.0);
            check;
        end procedure;
    begin
        wait for 2 ns;
        start_test;
        check;
        end_test("code is 0 before the first clock edge");
        wait until falling_edge(clk);

        start_test;
        sample(0.0); sample(0.00390625); sample(0.0039); sample(0.25); sample(0.5); sample(0.75);
        end_test("exact code transitions");

        start_test;
        sample(-0.2); sample(-5.0); sample(0.999); sample(1.0); sample(1.3); sample(3.9); sample(4.5);
        end_test("clamps to 0 and 255");

        start_test;
        vin <= 0.5;
        wait until falling_edge(clk);
        m1 := 128; m2 := 64;
        vin <= 0.9; wait for 1 ns; check;
        vin <= 0.1; wait for 3 ns; check;
        wait until falling_edge(clk);
        m1 := quant(0.1, 1.0); m2 := quant(0.1, 2.0); check;
        end_test("output only changes on the rising clock edge");

        start_test;
        for i in 0 to 899 loop sample(-0.05 + real(i) * 0.00131); end loop;
        end_test("ramp from -0.05 V to 1.13 V (900 samples)");

        start_test;
        for i in 0 to 499 loop sample(1.0 + 1.1 * sin(6.2831853 * real(i) / 97.0)); end loop;
        end_test("sine input, VREF 1.0 and 2.0 (500 samples)");

        report "TB_DONE";
        done <= true;
        std.env.finish;
    end process;
end architecture;
