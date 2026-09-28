library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity apb_regs is
    port (
        pclk    : in  std_logic;
        presetn : in  std_logic;
        psel    : in  std_logic;
        penable : in  std_logic;
        pwrite  : in  std_logic;
        paddr   : in  std_logic_vector(3 downto 0);
        pwdata  : in  std_logic_vector(31 downto 0);
        prdata  : out std_logic_vector(31 downto 0);
        pready  : out std_logic
    );
end entity;

architecture rtl of apb_regs is
    type regs_t is array (0 to 3) of std_logic_vector(31 downto 0);
    signal regs : regs_t;
    signal idx  : natural range 0 to 3;
begin
    idx <= to_integer(unsigned(paddr(1 downto 0)));
    pready <= '1';

    process (pclk)
    begin
        if rising_edge(pclk) then
            if presetn = '0' then
                regs <= (x"00000000", x"00000000", x"00000000", x"C0DE0001");
            elsif psel = '1' and penable = '1' and pwrite = '1' then
                regs(idx) <= pwdata;
            end if;
        end if;
    end process;

    prdata <= regs(idx) when psel = '1' and pwrite = '0' else (others => '0');
end architecture;
