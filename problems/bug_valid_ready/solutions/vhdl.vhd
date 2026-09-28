library ieee;
use ieee.std_logic_1164.all;

entity reg_slice is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        in_valid  : in  std_logic;
        in_data   : in  std_logic_vector(7 downto 0);
        in_ready  : out std_logic;
        out_valid : out std_logic;
        out_data  : out std_logic_vector(7 downto 0);
        out_ready : in  std_logic
    );
end entity;

architecture rtl of reg_slice is
    signal v   : std_logic := '0';
    signal rdy : std_logic;
begin
    rdy <= (not v) or out_ready;
    in_ready <= rdy;
    out_valid <= v;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                v <= '0';
            elsif in_valid = '1' and rdy = '1' then
                out_data <= in_data;
                v <= '1';
            elsif out_ready = '1' then
                v <= '0';
            end if;
        end if;
    end process;
end architecture;
