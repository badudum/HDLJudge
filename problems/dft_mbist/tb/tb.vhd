library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

entity tb is
end entity;

architecture sim of tb is
    signal clk, rst, start : std_logic := '0';
    signal mem_addr, mem_wdata, mem_rdata : std_logic_vector(3 downto 0);
    signal mem_we, busy, done, fail : std_logic;
    type mem_t is array (0 to 15) of std_logic_vector(3 downto 0);
    signal mem     : mem_t := (others => (others => '0'));
    signal fault   : natural := 0;
    signal tb_done : boolean := false;
    signal init_req : boolean := false;
    signal init_val : mem_t;
begin
    dut : entity work.mbist port map (clk => clk, rst => rst, start => start, mem_rdata => mem_rdata,
                                      mem_addr => mem_addr, mem_we => mem_we, mem_wdata => mem_wdata,
                                      busy => busy, done => done, fail => fail);

    clk <= not clk after 5 ns when not tb_done;

    -- memory model with injectable faults (see tb.sv for the list)
    process (mem_addr, mem, fault)
        variable ra : natural range 0 to 15;
        variable w  : std_logic_vector(3 downto 0);
    begin
        if is_x(mem_addr) then
            mem_rdata <= (others => 'X');
        else
            ra := to_integer(unsigned(mem_addr));
            if fault = 4 and ra = 7 then ra := 6; end if;
            w := mem(ra);
            if fault = 1 and ra = 5 then w(2) := '0'; end if;
            if fault = 2 and ra = 9 then w(0) := '1'; end if;
            mem_rdata <= w;
        end if;
    end process;

    process (clk)
        variable wa : natural range 0 to 15;
        variable wv : std_logic_vector(3 downto 0);
    begin
        if rising_edge(clk) then
            if init_req then
                mem <= init_val;
            elsif mem_we = '1' and not is_x(mem_addr) then
                wa := to_integer(unsigned(mem_addr));
                if fault = 4 and wa = 7 then wa := 6; end if;
                wv := mem_wdata;
                if fault = 5 and wa = 2 and mem(2)(3) = '0' then wv(3) := '0'; end if;
                mem(wa) <= wv;
                if fault = 3 and wa = 3 then mem(12)(1) <= not mem(12)(1); end if;
            end if;
        end if;
    end process;

    process
        variable errors : natural;
        variable detail : line;
        variable s1, s2 : positive := 82;
        variable r      : real;
        variable iv     : mem_t;

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

        procedure run_chip(f : natural; expect_fail : std_logic) is
            variable cycles : natural;
        begin
            fault <= f;
            for i in 0 to 15 loop
                uniform(s1, s2, r);
                iv(i) := std_logic_vector(to_unsigned(integer(floor(r * 16.0)) mod 16, 4));
            end loop;
            init_val <= iv;
            init_req <= true;
            wait until falling_edge(clk);
            init_req <= false;
            start <= '1';
            wait until falling_edge(clk);
            start <= '0';
            cycles := 1;
            while done /= '1' and cycles < 2000 loop
                wait until falling_edge(clk);
                cycles := cycles + 1;
            end loop;
            if done /= '1' then
                if errors = 0 then
                    deallocate(detail);
                    detail := new string'("fault model " & integer'image(f) & ": no done pulse within 2000 cycles");
                end if;
                errors := errors + 1;
            elsif fail /= expect_fail then
                if errors = 0 then
                    deallocate(detail);
                    detail := new string'("fault model " & integer'image(f) & ": expected fail=" &
                                          std_logic'image(expect_fail) & ", got " & std_logic'image(fail));
                end if;
                errors := errors + 1;
            end if;
            wait until falling_edge(clk);
        end procedure;
    begin
        rst <= '1';
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        rst <= '0';

        start_test; run_chip(0, '0'); end_test("good memory passes");
        start_test; run_chip(1, '1'); run_chip(2, '1'); end_test("stuck-at faults are detected");
        start_test; run_chip(5, '1'); end_test("transition fault is detected");
        start_test; run_chip(3, '1'); end_test("coupling fault is detected");
        start_test; run_chip(4, '1'); end_test("address decoder fault is detected");
        start_test; run_chip(0, '0'); end_test("fail is cleared by the next start");

        report "TB_DONE";
        tb_done <= true;
        std.env.finish;
    end process;
end architecture;
