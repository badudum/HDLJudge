library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dirty_tracker is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        op        : in  std_logic_vector(1 downto 0);
        index     : in  std_logic_vector(2 downto 0);
        valid     : out std_logic_vector(7 downto 0);
        dirty     : out std_logic_vector(7 downto 0);
        writeback : out std_logic;
        wb_index  : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of dirty_tracker is
    signal v, d : std_logic_vector(7 downto 0) := (others => '0');
begin
    valid <= v;
    dirty <= d;
    process (clk)
        variable i : natural range 0 to 7;
    begin
        if rising_edge(clk) then
            i := to_integer(unsigned(index));
            if rst = '1' then
                v <= (others => '0'); d <= (others => '0');
                writeback <= '0'; wb_index <= "000";
            else
                writeback <= '0';
                if (op = "10" or op = "11") and v(i) = '1' and d(i) = '1' then
                    writeback <= '1';
                    wb_index <= index;
                end if;
                case op is
                    when "01" => v(i) <= '1'; d(i) <= '1';
                    when "10" => v(i) <= '1'; d(i) <= '0';
                    when "11" => v(i) <= '0'; d(i) <= '0';
                    when others => null;
                end case;
            end if;
        end if;
    end process;
end architecture;
