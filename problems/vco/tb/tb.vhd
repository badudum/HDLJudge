library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.textio.all;

entity tb is
end entity;

architecture sim of tb is
    signal vctrl      : real := 0.0;
    signal out1, out2 : std_logic;
begin
    dut1 : entity work.vco port map (vctrl => vctrl, clk_out => out1);
    dut2 : entity work.vco generic map (F0 => 20.0e6, KVCO => 10.0e6) port map (vctrl => vctrl, clk_out => out2);

    watchdog : process
    begin
        wait for 2 ms;
        report "FAIL: watchdog - clk_out stopped toggling";
        std.env.finish;
    end process;

    process
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

        function clampf(x : real) return real is
        begin
            return realmax(1.0e6, realmin(1.0e9, x));
        end function;

        function to_ns(t : time) return real is
        begin
            return real(t / 1 fs) / 1.0e6;
        end function;

        procedure check(which : natural; v : real) is
            variable want, period, f, duty : real;
            variable t0, t1, th, tl : time;
        begin
            vctrl <= v;
            if which = 1 then
                want := clampf(100.0e6 + 50.0e6 * v);
                for k in 1 to 3 loop wait until rising_edge(out1); end loop;
                t0 := now;
                for k in 1 to 20 loop wait until rising_edge(out1); end loop;
                t1 := now; th := now;
                wait until falling_edge(out1);
                tl := now;
            else
                want := clampf(20.0e6 + 10.0e6 * v);
                for k in 1 to 3 loop wait until rising_edge(out2); end loop;
                t0 := now;
                for k in 1 to 20 loop wait until rising_edge(out2); end loop;
                t1 := now; th := now;
                wait until falling_edge(out2);
                tl := now;
            end if;
            period := to_ns(t1 - t0) / 20.0;
            f := 1.0e9 / period;
            duty := to_ns(tl - th) / period;
            if f < want * 0.995 or f > want * 1.005 then
                if errors = 0 then
                    deallocate(detail);
                    detail := new string'("dut" & integer'image(which) & " vctrl=" & real'image(v) &
                        ": expected " & real'image(want / 1.0e6) & " MHz, measured " & real'image(f / 1.0e6) & " MHz");
                end if;
                errors := errors + 1;
            elsif duty < 0.45 or duty > 0.55 then
                if errors = 0 then
                    deallocate(detail);
                    detail := new string'("dut" & integer'image(which) & " vctrl=" & real'image(v) &
                        ": duty cycle " & real'image(duty * 100.0) & " % (expected 50 %)");
                end if;
                errors := errors + 1;
            end if;
        end procedure;
    begin
        wait for 1 ns;
        start_test;
        check(1, 0.0);
        end_test("centre frequency (vctrl = 0)");

        start_test;
        check(1, 1.0); check(1, -1.0); check(1, 0.37); check(1, 4.0);
        end_test("tuning curve f = F0 + KVCO * vctrl");

        start_test;
        check(1, -5.0); check(1, 25.0);
        end_test("clamping to 1 MHz ... 1 GHz");

        start_test;
        check(2, 0.0); check(2, 3.0); check(2, -1.5);
        end_test("parameters F0 and KVCO are honored");

        report "TB_DONE";
        std.env.finish;
    end process;
end architecture;
