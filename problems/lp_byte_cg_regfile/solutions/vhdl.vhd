library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity byte_rf is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        we    : in  std_logic;
        waddr : in  std_logic_vector(1 downto 0);
        wbe   : in  std_logic_vector(3 downto 0);
        wdata : in  std_logic_vector(31 downto 0);
        raddr : in  std_logic_vector(1 downto 0);
        rdata : out std_logic_vector(31 downto 0);
        cg_en : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of byte_rf is
    type rf_t is array (0 to 3) of std_logic_vector(31 downto 0);
    signal regs : rf_t := (others => (others => '0'));
    signal en   : std_logic_vector(15 downto 0);
begin
    gen : for i in 0 to 15 generate
        en(i) <= '1' when we = '1' and to_integer(unsigned(waddr)) = i / 4 and wbe(i mod 4) = '1' else '0';
    end generate;
    cg_en <= en;
    rdata <= regs(to_integer(unsigned(raddr)));
    process (clk)
    begin
        if rising_edge(clk) then
            for i in 0 to 15 loop
                if rst = '1' then
                    regs(i / 4)(8 * (i mod 4) + 7 downto 8 * (i mod 4)) <= (others => '0');
                elsif en(i) = '1' then
                    regs(i / 4)(8 * (i mod 4) + 7 downto 8 * (i mod 4)) <= wdata(8 * (i mod 4) + 7 downto 8 * (i mod 4));
                end if;
            end loop;
        end if;
    end process;
end architecture;
