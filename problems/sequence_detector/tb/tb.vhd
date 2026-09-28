library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.textio.all;

entity tb is
end entity;

architecture sim of tb is
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal din      : std_logic := '0';
    signal detected : std_logic;
    signal done     : boolean := false;
begin
    dut : entity work.seq_detect port map (clk => clk, rst => rst, din => din, detected => detected);

    clk <= not clk after 5 ns when not done;

    process
        variable hist   : std_logic_vector(3 downto 0) := "0000";
        variable m_det  : std_logic := '0';
        variable errors : natural;
        variable detail : line;
        variable s1, s2 : positive := 5;
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
            if detected /= m_det then
                if errors = 0 then
                    deallocate(detail);
                    detail := new string'("at t=" & time'image(now) & " (last samples " &
                                          to_string(hist) & ") expected detected=" &
                                          std_logic'image(m_det) & ", got " & std_logic'image(detected));
                end if;
                errors := errors + 1;
            end if;
            rst <= rv; din <= dv;
            if rv = '1' then
                hist := "0000"; m_det := '0';
            else
                hist := hist(2 downto 0) & dv;
                if hist = "1011" then m_det := '1'; else m_det := '0'; end if;
            end if;
        end procedure;

        procedure send(bits : std_logic_vector) is
        begin
            for k in bits'range loop
                step('0', bits(k));
            end loop;
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
        step('1', '0'); send("00000");
        end_test("no detection after reset");

        start_test;
        send("1011"); send("00");
        end_test("detects a single 1011");

        start_test;
        send("1011011"); send("00");
        end_test("detects overlapping 1011011 twice");

        start_test;
        send("1101011"); send("00");
        end_test("recovers after a partial match 11 -> 1011");

        start_test;
        send("10101011"); send("00");
        end_test("recovers after 1010 -> 1011");

        start_test;
        send("1111000010010110"); send("00");
        end_test("rejects near misses");

        start_test;
        send("101"); step('1', '1'); send("011"); send("00");
        end_test("reset discards a partial match");

        start_test;
        for i in 1 to 1000 loop
            step(rbit(0.01), rbit(0.5));
        end loop;
        step('0', '0');
        end_test("1000 random bits");

        report "TB_DONE";
        done <= true;
        std.env.finish;
    end process;
end architecture;
