library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rename is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        ren_valid  : in  std_logic;
        rs1        : in  std_logic_vector(2 downto 0);
        rs2        : in  std_logic_vector(2 downto 0);
        rd         : in  std_logic_vector(2 downto 0);
        has_rd     : in  std_logic;
        free_valid : in  std_logic;
        free_preg  : in  std_logic_vector(3 downto 0);
        ren_ok     : out std_logic;
        stall      : out std_logic;
        ps1        : out std_logic_vector(3 downto 0);
        ps2        : out std_logic_vector(3 downto 0);
        pd         : out std_logic_vector(3 downto 0);
        old_pd     : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of rename is
    type rat_t is array (0 to 7) of unsigned(3 downto 0);
    type fifo_t is array (0 to 15) of unsigned(3 downto 0);
    signal rat        : rat_t;
    signal fifo       : fifo_t;
    signal head, tail : unsigned(3 downto 0);
    signal count      : natural range 0 to 16;
begin
    process (clk)
        variable alloc : boolean;
        variable c     : natural range 0 to 16;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                for i in 0 to 7 loop
                    rat(i)  <= to_unsigned(i, 4);
                    fifo(i) <= to_unsigned(i + 8, 4);
                end loop;
                head <= x"0"; tail <= x"8"; count <= 8;
                ren_ok <= '0'; stall <= '0';
            else
                alloc := ren_valid = '1' and has_rd = '1' and count /= 0;
                ren_ok <= '0'; stall <= '0';
                if ren_valid = '1' then
                    ps1 <= std_logic_vector(rat(to_integer(unsigned(rs1))));
                    ps2 <= std_logic_vector(rat(to_integer(unsigned(rs2))));
                    if has_rd = '0' or count /= 0 then ren_ok <= '1'; else stall <= '1'; end if;
                end if;
                c := count;
                if alloc then
                    pd     <= std_logic_vector(fifo(to_integer(head)));
                    old_pd <= std_logic_vector(rat(to_integer(unsigned(rd))));
                    rat(to_integer(unsigned(rd))) <= fifo(to_integer(head));
                    head <= head + 1;
                    c := c - 1;
                end if;
                if free_valid = '1' then
                    fifo(to_integer(tail)) <= unsigned(free_preg);
                    tail <= tail + 1;
                    c := c + 1;
                end if;
                count <= c;
            end if;
        end if;
    end process;
end architecture;
