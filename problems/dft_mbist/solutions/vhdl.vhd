library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mbist is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        start     : in  std_logic;
        mem_rdata : in  std_logic_vector(3 downto 0);
        mem_addr  : out std_logic_vector(3 downto 0);
        mem_we    : out std_logic;
        mem_wdata : out std_logic_vector(3 downto 0);
        busy      : out std_logic;
        done      : out std_logic;
        fail      : out std_logic
    );
end entity;

architecture rtl of mbist is
    signal elem   : natural range 0 to 5 := 0;
    signal phase  : std_logic := '0';
    signal addr   : unsigned(3 downto 0) := (others => '0');
    signal busy_r : std_logic := '0';
    signal fail_r : std_logic := '0';
    signal writing, down, last_addr, op_done : boolean;
    signal expect, wval : std_logic_vector(3 downto 0);
begin
    writing   <= busy_r = '1' and (elem = 0 or phase = '1');
    down      <= elem = 3 or elem = 4;
    last_addr <= (down and addr = 0) or (not down and addr = 15);
    op_done   <= elem = 0 or elem = 5 or phase = '1';
    expect    <= x"F" when elem = 2 or elem = 4 else x"0";
    wval      <= x"F" when elem = 1 or elem = 3 else x"0";

    mem_addr  <= std_logic_vector(addr);
    mem_we    <= '1' when writing else '0';
    mem_wdata <= wval;
    busy      <= busy_r;
    fail      <= fail_r;

    process (clk)
    begin
        if rising_edge(clk) then
            done <= '0';
            if rst = '1' then
                busy_r <= '0'; fail_r <= '0';
            elsif busy_r = '0' then
                if start = '1' then
                    busy_r <= '1'; fail_r <= '0';
                    elem <= 0; phase <= '0'; addr <= (others => '0');
                end if;
            else
                if elem /= 0 and not writing and mem_rdata /= expect then fail_r <= '1'; end if;
                if not op_done then
                    phase <= '1';
                else
                    phase <= '0';
                    if not last_addr then
                        if down then addr <= addr - 1; else addr <= addr + 1; end if;
                    elsif elem = 5 then
                        busy_r <= '0'; done <= '1';
                    else
                        elem <= elem + 1;
                        if elem = 2 or elem = 3 then addr <= x"F"; else addr <= x"0"; end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture;
