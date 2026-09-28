library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

entity tb is
end entity;

architecture sim of tb is
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '1';
    signal en    : std_logic := '0';
    signal count : std_logic_vector(3 downto 0);
    signal done  : boolean := false;
begin
    dut : entity work.counter port map (clk => clk, rst => rst, en => en, count => count);

    clk <= not clk after 5 ns when not done;

    process
        variable model  : unsigned(3 downto 0) := (others => '0');
        variable errors : natural;
        variable detail : line;
        variable s1, s2 : positive := 11;
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

        procedure mismatch(msg : string) is
        begin
            if errors = 0 then
                deallocate(detail);
                detail := new string'(msg);
            end if;
            errors := errors + 1;
        end procedure;

        procedure step(rv, ev : std_logic) is
        begin
            wait until falling_edge(clk);
            if count /= std_logic_vector(model) then
                mismatch("at t=" & time'image(now) & " expected count=" &
                         integer'image(to_integer(model)) & ", got " & to_hstring(count));
            end if;
            rst <= rv; en <= ev;
            if rv = '1' then model := (others => '0');
            elsif ev = '1' then model := model + 1;
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
        model := (others => '0');

        start_test;
        step('1', '1'); step('0', '0'); step('0', '0');
        end_test("reset clears the counter");

        start_test;
        for i in 1 to 20 loop step('0', '1'); end loop;
        step('0', '0');
        end_test("counts up and wraps from 15 to 0");

        start_test;
        for i in 1 to 6 loop step('0', '0'); end loop;
        end_test("holds its value when en=0");

        start_test;
        step('1', '1'); step('0', '0');
        end_test("reset has priority over enable");

        start_test;
        for i in 1 to 5 loop step('0', '1'); end loop;
        wait until falling_edge(clk);
        model := unsigned(count);
        rst <= '1';
        wait for 2 ns;
        if count /= std_logic_vector(model) then
            mismatch("count changed from " & to_hstring(model) & " to " & to_hstring(count) &
                     " before the clock edge");
        end if;
        wait until rising_edge(clk);
        wait for 1 ns;
        if count /= "0000" then
            mismatch("count is " & to_hstring(count) & " after the reset edge");
        end if;
        model := (others => '0');
        end_test("reset is synchronous");

        start_test;
        for i in 1 to 300 loop
            step(rbit(0.0625), rbit(0.5));
        end loop;
        step('0', '0');
        end_test("300 random cycles of en/rst");

        report "TB_DONE";
        done <= true;
        std.env.finish;
    end process;
end architecture;
