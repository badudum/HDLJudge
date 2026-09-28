library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.textio.all;

entity tb is
end entity;

architecture sim of tb is
    signal vp : real := 0.0;
    signal vn : real := 0.5;
    signal q1, q2 : std_logic;
begin
    dut1 : entity work.hyst_comp port map (vp => vp, vn => vn, q => q1);
    dut2 : entity work.hyst_comp generic map (VH => 0.4) port map (vp => vp, vn => vn, q => q2);

    process
        variable m1, m2 : std_logic := '0';
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

        function model(prev : std_logic; diff, vh : real) return std_logic is
        begin
            if diff > vh / 2.0 then return '1';
            elsif diff < -vh / 2.0 then return '0';
            else return prev;
            end if;
        end function;

        procedure apply(p, n : real) is
        begin
            vp <= p; vn <= n;
            m1 := model(m1, p - n, 0.1);
            m2 := model(m2, p - n, 0.4);
            wait for 1 ns;
            if q1 /= m1 or q2 /= m2 then
                if errors = 0 then
                    deallocate(detail);
                    detail := new string'("vp=" & real'image(p) & " vn=" & real'image(n) &
                        ": expected q=" & std_logic'image(m1) & " (VH=0.1) / q=" & std_logic'image(m2) &
                        " (VH=0.4), got " & std_logic'image(q1) & " / " & std_logic'image(q2));
                end if;
                errors := errors + 1;
            end if;
            wait for 9 ns;
        end procedure;
    begin
        wait for 5 ns;

        start_test;
        if q1 /= '0' or q2 /= '0' then
            errors := 1;
            deallocate(detail);
            detail := new string'("expected q=0 at start, got " & std_logic'image(q1) & " / " & std_logic'image(q2));
        end if;
        end_test("output starts low");

        start_test;
        apply(0.52, 0.5); apply(0.56, 0.5); apply(0.60, 0.5);
        end_test("switches high only above +VH/2");

        start_test;
        apply(0.52, 0.5); apply(0.48, 0.5); apply(0.46, 0.5);
        end_test("holds inside the hysteresis window");

        start_test;
        apply(0.44, 0.5); apply(0.40, 0.5); apply(0.5, 0.5);
        end_test("switches low only below -VH/2");

        start_test;
        apply(0.5, 0.5); apply(0.72, 0.5); apply(0.55, 0.5); apply(0.35, 0.5); apply(0.28, 0.5);
        end_test("parameter VH is honored (VH = 0.4)");

        start_test;
        apply(1.0, 1.2); apply(1.0, 0.97); apply(1.0, 0.93); apply(1.0, 1.04); apply(1.0, 1.08);
        end_test("reacts to changes of vn");

        start_test;
        for i in 0 to 399 loop
            apply(0.9 + 0.35 * sin(real(i) * 0.07) + 0.03 * sin(real(i) * 1.3), 0.9);
        end loop;
        end_test("noisy sine sweep (400 points)");

        report "TB_DONE";
        std.env.finish;
    end process;
end architecture;
