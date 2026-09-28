library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sort4 is
    port (in0, in1, in2, in3 : in std_logic_vector(7 downto 0);
          out0, out1, out2, out3 : out std_logic_vector(7 downto 0));
end entity;

architecture rtl of sort4 is
begin
    process (in0, in1, in2, in3)
        type arr is array (0 to 3) of unsigned(7 downto 0);
        variable x : arr;
        procedure cas(i, j : natural) is
            variable t : unsigned(7 downto 0);
        begin
            if x(j) < x(i) then t := x(i); x(i) := x(j); x(j) := t; end if;
        end procedure;
    begin
        x := (unsigned(in0), unsigned(in1), unsigned(in2), unsigned(in3));
        cas(0, 1); cas(2, 3); cas(0, 2); cas(1, 3); cas(1, 2);
        out0 <= std_logic_vector(x(0)); out1 <= std_logic_vector(x(1));
        out2 <= std_logic_vector(x(2)); out3 <= std_logic_vector(x(3));
    end process;
end architecture;
