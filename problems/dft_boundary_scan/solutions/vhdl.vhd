library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bsr4 is
    port (clk, rst, capture_dr, shift_dr, update_dr, mode, scan_in : in std_logic;
          data_in : in std_logic_vector(3 downto 0); data_out : out std_logic_vector(3 downto 0); scan_out : out std_logic);
end entity;

architecture rtl of bsr4 is
    signal cap, upd : std_logic_vector(3 downto 0) := (others => '0');
begin
    scan_out <= cap(3);
    data_out <= upd when mode = '1' else data_in;
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then cap <= (others => '0'); upd <= (others => '0');
            elsif capture_dr = '1' then cap <= data_in;
            elsif shift_dr = '1' then cap <= cap(2 downto 0) & scan_in;
            elsif update_dr = '1' then upd <= cap;
            end if;
        end if;
    end process;
end architecture;
