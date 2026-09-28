library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
    port (
        clk    : in  std_logic;
        we     : in  std_logic;
        waddr  : in  std_logic_vector(4 downto 0);
        wdata  : in  std_logic_vector(31 downto 0);
        raddr1 : in  std_logic_vector(4 downto 0);
        raddr2 : in  std_logic_vector(4 downto 0);
        rdata1 : out std_logic_vector(31 downto 0);
        rdata2 : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of regfile is
    type regs_t is array (0 to 31) of std_logic_vector(31 downto 0);
    signal regs : regs_t;

    function rd(signal r : regs_t; a, wa : std_logic_vector; w : std_logic; wd : std_logic_vector)
        return std_logic_vector is
    begin
        if unsigned(a) = 0 then
            return x"00000000";
        elsif w = '1' and wa = a then
            return wd;
        else
            return r(to_integer(unsigned(a)));
        end if;
    end function;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if we = '1' and unsigned(waddr) /= 0 then
                regs(to_integer(unsigned(waddr))) <= wdata;
            end if;
            rdata1 <= rd(regs, raddr1, waddr, we, wdata);
            rdata2 <= rd(regs, raddr2, waddr, we, wdata);
        end if;
    end process;
end architecture;
