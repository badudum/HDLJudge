library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scoreboard is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        issue_valid : in  std_logic;
        rd          : in  std_logic_vector(2 downto 0);
        rs1         : in  std_logic_vector(2 downto 0);
        rs2         : in  std_logic_vector(2 downto 0);
        wb_valid    : in  std_logic;
        wb_rd       : in  std_logic_vector(2 downto 0);
        issued      : out std_logic;
        pending     : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of scoreboard is
    signal pend : std_logic_vector(7 downto 0) := (others => '0');
begin
    pending <= pend;
    process (clk)
        variable aw : std_logic_vector(7 downto 0);
        variable go    : boolean;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pend <= (others => '0');
                issued <= '0';
            else
                aw := pend;
                if wb_valid = '1' then aw(to_integer(unsigned(wb_rd))) := '0'; end if;
                aw(0) := '0';
                go := issue_valid = '1' and aw(to_integer(unsigned(rs1))) = '0'
                      and aw(to_integer(unsigned(rs2))) = '0' and aw(to_integer(unsigned(rd))) = '0';
                if go then
                    aw(to_integer(unsigned(rd))) := '1';
                    issued <= '1';
                else
                    issued <= '0';
                end if;
                aw(0) := '0';
                pend <= aw;
            end if;
        end if;
    end process;
end architecture;
