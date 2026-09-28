library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_alu is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        stall     : in  std_logic;
        valid_in  : in  std_logic;
        op        : in  std_logic_vector(1 downto 0);
        a         : in  std_logic_vector(15 downto 0);
        b         : in  std_logic_vector(15 downto 0);
        valid_out : out std_logic;
        y         : out std_logic_vector(15 downto 0);
        zero      : out std_logic
    );
end entity;

architecture rtl of pipe_alu is
    signal v1     : std_logic := '0';
    signal op1    : std_logic_vector(1 downto 0);
    signal a1, b1 : unsigned(15 downto 0);
begin
    process (clk)
        variable r : unsigned(15 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                v1 <= '0'; valid_out <= '0';
            elsif stall = '0' then
                case op1 is
                    when "00" => r := a1 + b1;
                    when "01" => r := a1 - b1;
                    when "10" => r := a1 and b1;
                    when others => r := a1 xor b1;
                end case;
                valid_out <= v1;
                y <= std_logic_vector(r);
                if r = 0 then zero <= '1'; else zero <= '0'; end if;
                v1 <= valid_in; op1 <= op; a1 <= unsigned(a); b1 <= unsigned(b);
            end if;
        end if;
    end process;
end architecture;
