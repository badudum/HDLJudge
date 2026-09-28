library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

entity tb is
end entity;

architecture sim of tb is
    signal clk, rst, wr_en, rd_en : std_logic := '0';
    signal din, dout  : std_logic_vector(7 downto 0) := (others => '0');
    signal full, empty : std_logic;
    signal count      : std_logic_vector(3 downto 0);
    signal done       : boolean := false;
begin
    dut : entity work.sync_fifo port map (clk => clk, rst => rst, wr_en => wr_en, din => din,
                                          rd_en => rd_en, dout => dout, full => full,
                                          empty => empty, count => count);

    clk <= not clk after 5 ns when not done;

    process
        type q_t is array (0 to 7) of std_logic_vector(7 downto 0);
        variable q      : q_t;
        variable q_head, q_cnt : natural := 0;
        variable m_dout : std_logic_vector(7 downto 0) := (others => '0');
        variable errors : natural;
        variable detail : line;
        variable s1, s2 : positive := 17;
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

        function b(v : boolean) return std_logic is
        begin
            if v then return '1'; else return '0'; end if;
        end function;

        procedure step(rv, wv : std_logic; d : std_logic_vector(7 downto 0); rdv : std_logic) is
            variable do_w, do_r : boolean;
        begin
            wait until falling_edge(clk);
            if count /= std_logic_vector(to_unsigned(q_cnt, 4)) or full /= b(q_cnt = 8)
               or empty /= b(q_cnt = 0) or dout /= m_dout then
                if errors = 0 then
                    deallocate(detail);
                    detail := new string'("at t=" & time'image(now) & " expected count=" &
                        integer'image(q_cnt) & " full=" & std_logic'image(b(q_cnt = 8)) &
                        " empty=" & std_logic'image(b(q_cnt = 0)) & " dout=" & to_hstring(m_dout) &
                        ", got count=" & to_hstring(count) & " full=" & std_logic'image(full) &
                        " empty=" & std_logic'image(empty) & " dout=" & to_hstring(dout));
                end if;
                errors := errors + 1;
            end if;
            rst <= rv; wr_en <= wv; din <= d; rd_en <= rdv;
            if rv = '1' then
                q_head := 0; q_cnt := 0; m_dout := (others => '0');
            else
                do_w := wv = '1' and q_cnt < 8;
                do_r := rdv = '1' and q_cnt > 0;
                if do_r then
                    m_dout := q(q_head);
                    q_head := (q_head + 1) mod 8;
                    q_cnt := q_cnt - 1;
                end if;
                if do_w then
                    q((q_head + q_cnt) mod 8) := d;
                    q_cnt := q_cnt + 1;
                end if;
            end if;
        end procedure;

        function byte(n : natural) return std_logic_vector is
        begin
            return std_logic_vector(to_unsigned(n mod 256, 8));
        end function;

        impure function rnd(p : real) return std_logic is
        begin
            uniform(s1, s2, r);
            return b(r < p);
        end function;

        impure function rbyte return std_logic_vector is
        begin
            uniform(s1, s2, r);
            return byte(integer(floor(r * 256.0)));
        end function;
    begin
        wait until falling_edge(clk);
        rst <= '1';
        wait until falling_edge(clk);

        start_test;
        step('1', '0', x"00", '0'); step('0', '0', x"00", '0');
        end_test("empty after reset");

        start_test;
        for i in 0 to 7 loop step('0', '1', byte(16#A0# + i), '0'); end loop;
        step('0', '0', x"00", '0');
        end_test("fills up to 8 entries and asserts full");

        start_test;
        step('0', '1', x"EE", '0'); step('0', '1', x"EF", '0'); step('0', '0', x"00", '0');
        end_test("writes while full are ignored");

        start_test;
        for i in 0 to 7 loop step('0', '0', x"00", '1'); end loop;
        step('0', '0', x"00", '0');
        end_test("reads back in FIFO order and asserts empty");

        start_test;
        step('0', '0', x"00", '1'); step('0', '0', x"00", '1'); step('0', '0', x"00", '0');
        end_test("reads while empty are ignored (dout holds)");

        start_test;
        step('0', '1', x"11", '1'); step('0', '1', x"22", '1'); step('0', '1', x"33", '1');
        step('0', '0', x"00", '1'); step('0', '0', x"00", '0');
        end_test("simultaneous read and write");

        start_test;
        for i in 0 to 7 loop step('0', '1', byte(i * 3), '0'); end loop;
        for i in 0 to 3 loop step('0', '1', byte(16#50# + i), '1'); end loop;
        step('0', '0', x"00", '0');
        end_test("read+write while full performs only the read");

        start_test;
        step('1', '1', x"99", '1'); step('0', '0', x"00", '0');
        end_test("reset empties the FIFO");

        start_test;
        for i in 1 to 2000 loop
            if (i / 128) mod 2 = 0 then
                step(rnd(0.005), rnd(0.75), rbyte, rnd(0.4));   -- mostly filling
            else
                step(rnd(0.005), rnd(0.4), rbyte, rnd(0.75));   -- mostly draining
            end if;
        end loop;
        step('0', '0', x"00", '0');
        end_test("2000 random cycles");

        report "TB_DONE";
        done <= true;
        std.env.finish;
    end process;
end architecture;
