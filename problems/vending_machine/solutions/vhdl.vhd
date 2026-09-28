library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        coin     : in  std_logic_vector(1 downto 0);
        dispense : out std_logic;
        change   : out std_logic_vector(5 downto 0);
        credit   : out std_logic_vector(5 downto 0)
    );
end entity;

architecture rtl of vending is
    signal cred : unsigned(5 downto 0) := (others => '0');
begin
    credit <= std_logic_vector(cred);

    process (clk)
        variable total : unsigned(5 downto 0);
    begin
        if rising_edge(clk) then
            case coin is
                when "01"   => total := cred + 5;
                when "10"   => total := cred + 10;
                when "11"   => total := cred + 25;
                when others => total := cred;
            end case;
            if rst = '1' then
                cred <= (others => '0'); dispense <= '0'; change <= (others => '0');
            elsif total >= 30 then
                cred <= (others => '0'); dispense <= '1'; change <= std_logic_vector(total - 30);
            else
                cred <= total; dispense <= '0'; change <= (others => '0');
            end if;
        end if;
    end process;
end architecture;
