library ieee;
use ieee.std_logic_1164.all;

entity pipe3 is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        stall     : in  std_logic;
        flush     : in  std_logic;
        in_valid  : in  std_logic;
        in_data   : in  std_logic_vector(15 downto 0);
        out_valid : out std_logic;
        out_data  : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of pipe3 is
    signal v1, v2, v3 : std_logic := '0';
    signal d1, d2, d3 : std_logic_vector(15 downto 0);
begin
    out_valid <= v3;
    out_data  <= d3;
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                v1 <= '0'; v2 <= '0'; v3 <= '0';
            elsif flush = '1' then
                v3 <= v2; d3 <= d2;
                v2 <= '0'; v1 <= '0';
            elsif stall = '0' then
                v3 <= v2; d3 <= d2;
                v2 <= v1; d2 <= d1;
                v1 <= in_valid; d1 <= in_data;
            end if;
        end if;
    end process;
end architecture;
