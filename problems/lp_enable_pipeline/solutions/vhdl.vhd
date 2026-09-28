library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gated_pipe is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        in_valid  : in  std_logic;
        in_data   : in  std_logic_vector(7 downto 0);
        out_valid : out std_logic;
        out_data  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of gated_pipe is
    signal v1, v2, v3 : std_logic := '0';
    signal d1, d2, d3 : unsigned(7 downto 0) := (others => '0');
begin
    out_valid <= v3;
    out_data <= std_logic_vector(d3);
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                v1 <= '0'; v2 <= '0'; v3 <= '0';
                d1 <= (others => '0'); d2 <= (others => '0'); d3 <= (others => '0');
            else
                v1 <= in_valid; v2 <= v1; v3 <= v2;
                if in_valid = '1' then d1 <= unsigned(in_data) xor x"5A"; end if;
                if v1 = '1' then d2 <= d1 + 1; end if;
                if v2 = '1' then d3 <= rotate_left(d2, 1); end if;
            end if;
        end if;
    end process;
end architecture;
