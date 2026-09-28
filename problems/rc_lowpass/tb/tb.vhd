library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.textio.all;

entity tb is
end entity;

architecture sim of tb is
    signal clk  : std_logic := '0';
    signal vin  : real := 0.0;
    signal vout1, vout2 : real;
    signal done : boolean := false;
begin
    dut1 : entity work.rc_lpf port map (clk => clk, vin => vin, vout => vout1);
    dut2 : entity work.rc_lpf generic map (TAU => 200.0e-9) port map (clk => clk, vin => vin, vout => vout2);

    clk <= not clk after 5 ns when not done;   -- TS = 10 ns

    process
        constant a1 : real := 1.0 - exp(-10.0e-9 / 1.0e-6);
        constant a2 : real := 1.0 - exp(-10.0e-9 / 200.0e-9);
        variable m1, m2 : real := 0.0;
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

        procedure check is
        begin
            if not (abs(vout1 - m1) <= 1.0e-9) or not (abs(vout2 - m2) <= 1.0e-9) then
                if errors = 0 then
                    deallocate(detail);
                    detail := new string'("at t=" & time'image(now) & ": expected vout=" & real'image(m1) &
                        " (TAU=1us) / " & real'image(m2) & " (TAU=200ns), got " & real'image(vout1) &
                        " / " & real'image(vout2));
                end if;
                errors := errors + 1;
            end if;
        end procedure;

        procedure drive(v : real; n : natural) is
        begin
            vin <= v;
            for k in 1 to n loop
                wait until falling_edge(clk);
                m1 := m1 + (v - m1) * a1;
                m2 := m2 + (v - m2) * a2;
                check;
            end loop;
        end procedure;
    begin
        wait for 2 ns;
        start_test;
        check;
        end_test("vout starts at 0.0");
        wait until falling_edge(clk);

        start_test;
        drive(0.0, 5);
        end_test("stays at 0 with zero input");

        start_test;
        drive(1.0, 100);
        end_test("unit step response matches the recurrence");

        start_test;
        if not (abs(vout1 - (1.0 - exp(-1.0))) < 0.005) then
            errors := 1;
            deallocate(detail);
            detail := new string'("after one TAU expected about 0.632, got " & real'image(vout1));
        end if;
        end_test("reaches 63.2% after one time constant");

        start_test;
        drive(1.0, 300);
        drive(-0.5, 400);
        end_test("settles and discharges toward a new level");

        start_test;
        for i in 0 to 999 loop
            drive(sin(MATH_2_PI * real(i) / 250.0) + 0.3 * sin(MATH_2_PI * real(i) / 9.0), 1);
        end loop;
        end_test("filters a two-tone input (1000 steps)");

        report "TB_DONE";
        done <= true;
        std.env.finish;
    end process;
end architecture;
