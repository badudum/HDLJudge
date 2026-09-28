library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity credit_tx is
    port (clk, rst, in_valid : in std_logic; in_data : in std_logic_vector(7 downto 0); in_ready : out std_logic;
          tx_valid : out std_logic; tx_data : out std_logic_vector(7 downto 0); credit_ret : in std_logic;
          credits : out std_logic_vector(2 downto 0));
end entity;

architecture rtl of credit_tx is
    signal cr : unsigned(2 downto 0) := to_unsigned(4, 3);
    signal rdy : std_logic;
begin
    rdy <= '0' when cr = 0 else '1';
    in_ready <= rdy;
    credits <= std_logic_vector(cr);
    process (clk)
        variable n : unsigned(2 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cr <= to_unsigned(4, 3); tx_valid <= '0';
            else
                n := cr;
                tx_valid <= in_valid and rdy;
                if in_valid = '1' and rdy = '1' then tx_data <= in_data; n := n - 1; end if;
                if credit_ret = '1' then n := n + 1; end if;
                cr <= n;
            end if;
        end if;
    end process;
end architecture;
