library ieee;
use ieee.std_logic_1164.all;

entity forwarding_unit is
    port (
        ex_rs1        : in  std_logic_vector(4 downto 0);
        ex_rs2        : in  std_logic_vector(4 downto 0);
        mem_rd        : in  std_logic_vector(4 downto 0);
        mem_reg_write : in  std_logic;
        wb_rd         : in  std_logic_vector(4 downto 0);
        wb_reg_write  : in  std_logic;
        fwd_a         : out std_logic_vector(1 downto 0);
        fwd_b         : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of forwarding_unit is
    function sel(rs, mrd, wrd : std_logic_vector(4 downto 0); mw, ww : std_logic) return std_logic_vector is
    begin
        if mw = '1' and mrd /= "00000" and mrd = rs then
            return "10";
        elsif ww = '1' and wrd /= "00000" and wrd = rs then
            return "01";
        else
            return "00";
        end if;
    end function;
begin
    fwd_a <= sel(ex_rs1, mem_rd, wb_rd, mem_reg_write, wb_reg_write);
    fwd_b <= sel(ex_rs2, mem_rd, wb_rd, mem_reg_write, wb_reg_write);
end architecture;
