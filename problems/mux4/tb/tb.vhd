library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb is
end entity;

architecture sim of tb is
    signal a, b, c, d, y : std_logic_vector(7 downto 0);
    signal sel           : std_logic_vector(1 downto 0);
begin
    dut : entity work.mux4 port map (a => a, b => b, c => c, d => d, sel => sel, y => y);

    process
        variable s1, s2 : positive := 7;
        variable r      : real;
        variable errors : natural;
        variable exp_y  : std_logic_vector(7 downto 0);
        impure function rnd8 return std_logic_vector is
        begin
            uniform(s1, s2, r);
            return std_logic_vector(to_unsigned(integer(floor(r * 256.0)), 8));
        end function;
    begin
        for s in 0 to 3 loop
            errors := 0;
            for i in 1 to 64 loop
                a <= rnd8; b <= rnd8; c <= rnd8; d <= rnd8;
                sel <= std_logic_vector(to_unsigned(s, 2));
                wait for 5 ns;
                case s is
                    when 0 => exp_y := a;
                    when 1 => exp_y := b;
                    when 2 => exp_y := c;
                    when others => exp_y := d;
                end case;
                if y /= exp_y then
                    if errors = 0 then
                        report "FAIL: sel=" & integer'image(s) & " a=" & to_hstring(a) &
                               " b=" & to_hstring(b) & " c=" & to_hstring(c) & " d=" & to_hstring(d) &
                               " -> expected y=" & to_hstring(exp_y) & ", got " & to_hstring(y);
                    end if;
                    errors := errors + 1;
                end if;
                wait for 5 ns;
            end loop;
            if errors = 0 then
                report "PASS: sel=" & integer'image(s) & " selects the right input (64 random vectors)";
            end if;
        end loop;

        a <= x"11"; b <= x"22"; c <= x"33"; d <= x"44"; sel <= "00";
        wait for 5 ns;
        errors := 0;
        for s in 0 to 3 loop
            sel <= std_logic_vector(to_unsigned(s, 2));
            wait for 1 ns;
            if y /= std_logic_vector(to_unsigned(17 * (s + 1), 8)) then
                errors := errors + 1;
            end if;
        end loop;
        if errors = 0 then
            report "PASS: output follows sel changes immediately";
        else
            report "FAIL: output follows sel changes immediately (" & integer'image(errors) & " mismatches)";
        end if;
        report "TB_DONE";
        std.env.finish;
    end process;
end architecture;
