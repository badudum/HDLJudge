library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.textio.all;

entity tb is
end entity;

architecture sim of tb is
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '1';
    signal din   : std_logic := '0';
    signal pulse : std_logic;
    signal done  : boolean := false;
begin
    dut : entity work.edge_detect port map (clk => clk, rst => rst, din => din, pulse => pulse);

    clk <= not clk after 5 ns when not done;

    process
        variable m_prev, m_pulse : std_logic := '0';
        variable errors : natural;
        variable detail : line;
        variable s1, s2 : positive := 3;
        variable r      : real;

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

        procedure step(rv, dv : std_logic) is
        begin
            wait until falling_edge(clk);
            if pulse /= m_pulse then
                if errors = 0 then
                    deallocate(detail);
                    detail := new string'("at t=" & time'image(now) & " expected pulse=" &
                                          std_logic'image(m_pulse) & ", got " & std_logic'image(pulse));
                end if;
                errors := errors + 1;
            end if;
            rst <= rv; din <= dv;
            if rv = '1' then
                m_prev := '0'; m_pulse := '0';
            else
                m_pulse := dv and not m_prev; m_prev := dv;
            end if;
        end procedure;

        impure function rbit(p : real) return std_logic is
        begin
            uniform(s1, s2, r);
            if r < p then return '1'; else return '0'; end if;
        end function;
    begin
        wait until falling_edge(clk);
        wait until falling_edge(clk);

        start_test;
        step('1', '0'); step('0', '0'); step('0', '0');
        end_test("pulse is low after reset");

        start_test;
        step('0', '1'); step('0', '1'); step('0', '1'); step('0', '1'); step('0', '0'); step('0', '0');
        end_test("single one-cycle pulse on a long high input");

        start_test;
        for i in 0 to 9 loop
            if i mod 2 = 1 then step('0', '1'); else step('0', '0'); end if;
        end loop;
        step('0', '0');
        end_test("alternating input 0101...");

        start_test;
        step('0', '0'); step('0', '0'); step('0', '0'); step('0', '0');
        end_test("no pulse while input is low");

        start_test;
        step('0', '1'); step('1', '1'); step('0', '1'); step('0', '1'); step('0', '0');
        end_test("reset clears the stored sample");

        start_test;
        for i in 1 to 400 loop
            step(rbit(0.03), rbit(0.5));
        end loop;
        step('0', '0');
        end_test("400 random cycles");

        report "TB_DONE";
        done <= true;
        std.env.finish;
    end process;
end architecture;
