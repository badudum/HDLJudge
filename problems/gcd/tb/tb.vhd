library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

entity tb is
end entity;

architecture sim of tb is
    signal clk, rst, start : std_logic := '0';
    signal a, b, result    : std_logic_vector(15 downto 0) := (others => '0');
    signal busy, done      : std_logic;
    signal tb_done         : boolean := false;
begin
    dut : entity work.gcd16 port map (clk => clk, rst => rst, start => start, a => a, b => b,
                                      busy => busy, done => done, result => result);

    clk <= not clk after 5 ns when not tb_done;

    process
        variable errors : natural;
        variable detail : line;
        variable s1, s2 : positive := 34;
        variable r      : real;

        function gold(x0, y0 : natural) return natural is
            variable x, y, t : natural;
        begin
            x := x0; y := y0;
            while y /= 0 loop
                t := x mod y; x := y; y := t;
            end loop;
            return x;
        end function;

        impure function rnd16 return natural is
        begin
            uniform(s1, s2, r);
            return integer(floor(r * 65536.0)) mod 65536;
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

        procedure run(x, y : natural; inject : boolean) is
            variable want   : natural;
            variable cycles : natural;
            variable tag    : line;
        begin
            want := gold(x, y);
            deallocate(tag);
            tag := new string'("gcd(" & integer'image(x) & ", " & integer'image(y) & "): ");
            wait until falling_edge(clk);
            a <= std_logic_vector(to_unsigned(x, 16));
            b <= std_logic_vector(to_unsigned(y, 16));
            start <= '1';
            wait until falling_edge(clk);
            start <= '0';
            a <= std_logic_vector(to_unsigned(rnd16, 16));
            b <= std_logic_vector(to_unsigned(rnd16, 16));
            cycles := 1;
            if done /= '1' and busy /= '1' then
                fail(tag.all & "busy must be 1 while computing");
            end if;
            if inject and done /= '1' then
                a <= std_logic_vector(to_unsigned(12, 16));
                b <= std_logic_vector(to_unsigned(8, 16));
                start <= '1';
                wait until falling_edge(clk);
                start <= '0';
                cycles := cycles + 1;
            end if;
            while done /= '1' and cycles < 140000 loop
                wait until falling_edge(clk);
                cycles := cycles + 1;
            end loop;
            if done /= '1' then
                fail(tag.all & "no done pulse within 140000 cycles");
            else
                if result /= std_logic_vector(to_unsigned(want, 16)) then
                    fail(tag.all & "expected " & integer'image(want) & ", got " &
                         integer'image(to_integer(unsigned(result))));
                end if;
                if busy /= '0' then
                    fail(tag.all & "busy must be 0 in the done cycle");
                end if;
                wait until falling_edge(clk);
                if done /= '0' then
                    fail(tag.all & "done must be a one-cycle pulse");
                end if;
                if result /= std_logic_vector(to_unsigned(want, 16)) then
                    fail(tag.all & "result must hold after done");
                end if;
            end if;
        end procedure;
    begin
        rst <= '1';
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        rst <= '0';

        start_test;
        run(48, 18, false); run(18, 48, false); run(7, 21, false); run(100, 75, false); run(1, 1, false);
        end_test("small pairs");

        start_test;
        run(0, 25, false); run(25, 0, false); run(0, 0, false); run(1234, 1234, false);
        end_test("zero and equal operands");

        start_test;
        run(65521, 65519, false); run(1024, 243, false); run(40000, 39999, false);
        end_test("coprime pairs");

        start_test;
        run(65535, 1, false); run(1, 65535, false);
        end_test("lopsided operands (65535, 1)");

        start_test;
        run(3000, 1, true);
        end_test("start is ignored while busy");

        start_test;
        for i in 1 to 40 loop
            run(rnd16, rnd16, false);
        end loop;
        end_test("40 random pairs");

        report "TB_DONE";
        tb_done <= true;
        std.env.finish;
    end process;
end architecture;
