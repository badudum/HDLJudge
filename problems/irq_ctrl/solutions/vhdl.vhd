library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity irq_ctrl is
    port (clk, rst : in std_logic; irq_in : in std_logic_vector(7 downto 0);
          mask_we : in std_logic; mask_data : in std_logic_vector(7 downto 0); ack : in std_logic;
          irq : out std_logic; id : out std_logic_vector(2 downto 0);
          pending, mask : out std_logic_vector(7 downto 0));
end entity;

architecture rtl of irq_ctrl is
    signal p, m, prev, en : std_logic_vector(7 downto 0) := (others => '0');
    signal idv : natural range 0 to 7;
    signal any : std_logic;
begin
    en <= p and m;
    process (en)
        variable v : natural range 0 to 7;
    begin
        v := 0;
        for i in 7 downto 0 loop
            if en(i) = '1' then v := i; end if;
        end loop;
        idv <= v;
    end process;
    any <= '0' when en = x"00" else '1';
    irq <= any;
    id <= std_logic_vector(to_unsigned(idv, 3));
    pending <= p;
    mask <= m;
    process (clk)
        variable clr : std_logic_vector(7 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                p <= (others => '0'); m <= (others => '0'); prev <= (others => '0');
            else
                clr := (others => '0');
                if ack = '1' and any = '1' then clr(idv) := '1'; end if;
                p <= (p and not clr) or (irq_in and not prev);
                prev <= irq_in;
                if mask_we = '1' then m <= mask_data; end if;
            end if;
        end if;
    end process;
end architecture;
