library ieee;
use ieee.std_logic_1164.all;

entity rv32i_decode is
    port (
        instr     : in  std_logic_vector(31 downto 0);
        fmt       : out std_logic_vector(2 downto 0);
        imm       : out std_logic_vector(31 downto 0);
        reg_write : out std_logic;
        mem_read  : out std_logic;
        mem_write : out std_logic;
        branch    : out std_logic;
        jump      : out std_logic
    );
end entity;

architecture rtl of rv32i_decode is
begin
    process (instr)
        variable s : std_logic;
    begin
        s := instr(31);
        reg_write <= '0'; mem_read <= '0'; mem_write <= '0'; branch <= '0'; jump <= '0';
        fmt <= "111";
        imm <= (others => '0');
        case instr(6 downto 0) is
            when "0110011" =>
                fmt <= "000"; reg_write <= '1';
            when "0010011" | "0000011" | "1100111" =>
                fmt <= "001"; reg_write <= '1';
                imm <= (31 downto 12 => s) & instr(31 downto 20);
                if instr(6 downto 0) = "0000011" then mem_read <= '1'; end if;
                if instr(6 downto 0) = "1100111" then jump <= '1'; end if;
            when "0100011" =>
                fmt <= "010"; mem_write <= '1';
                imm <= (31 downto 12 => s) & instr(31 downto 25) & instr(11 downto 7);
            when "1100011" =>
                fmt <= "011"; branch <= '1';
                imm <= (31 downto 13 => s) & s & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0';
            when "0110111" | "0010111" =>
                fmt <= "100"; reg_write <= '1';
                imm <= instr(31 downto 12) & x"000";
            when "1101111" =>
                fmt <= "101"; reg_write <= '1'; jump <= '1';
                imm <= (31 downto 21 => s) & s & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0';
            when others => null;
        end case;
    end process;
end architecture;
