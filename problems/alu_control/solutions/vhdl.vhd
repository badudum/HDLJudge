library ieee;
use ieee.std_logic_1164.all;

entity alu_control is
    port (
        alu_op   : in  std_logic_vector(1 downto 0);
        funct3   : in  std_logic_vector(2 downto 0);
        funct7_5 : in  std_logic;
        alu_ctrl : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of alu_control is
begin
    process (alu_op, funct3, funct7_5)
    begin
        if alu_op = "00" then
            alu_ctrl <= x"0";
        elsif alu_op = "01" then
            alu_ctrl <= x"1";
        else
            case funct3 is
                when "000" =>
                    if alu_op = "10" and funct7_5 = '1' then alu_ctrl <= x"1"; else alu_ctrl <= x"0"; end if;
                when "001" => alu_ctrl <= x"6";
                when "010" => alu_ctrl <= x"9";
                when "011" => alu_ctrl <= x"A";
                when "100" => alu_ctrl <= x"4";
                when "101" =>
                    if funct7_5 = '1' then alu_ctrl <= x"8"; else alu_ctrl <= x"7"; end if;
                when "110" => alu_ctrl <= x"3";
                when others => alu_ctrl <= x"2";
            end case;
        end if;
    end process;
end architecture;
