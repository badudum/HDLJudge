library ieee;
use ieee.std_logic_1164.all;

entity req_ack_rx is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        req      : in  std_logic;
        data_in  : in  std_logic_vector(7 downto 0);
        ack      : out std_logic;
        data_out : out std_logic_vector(7 downto 0);
        strobe   : out std_logic
    );
end entity;

architecture rtl of req_ack_rx is
    signal a : std_logic := '0';
begin
    ack <= a;
    process (clk)
    begin
        if rising_edge(clk) then
            strobe <= '0';
            if rst = '1' then
                a <= '0';
                data_out <= (others => '0');
            elsif a = '0' then
                if req = '1' then
                    a <= '1';
                    strobe <= '1';
                    data_out <= data_in;
                end if;
            elsif req = '0' then
                a <= '0';
            end if;
        end if;
    end process;
end architecture;
