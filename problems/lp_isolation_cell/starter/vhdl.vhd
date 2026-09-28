library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iso_cells is
    port (
        iso_en   : in  std_logic;
        pd_data  : in  std_logic_vector(7 downto 0);
        pd_valid : in  std_logic;
        pd_req_n : in  std_logic;
        ao_data  : out std_logic_vector(7 downto 0);
        ao_valid : out std_logic;
        ao_req_n : out std_logic
    );
end entity;

architecture rtl of iso_cells is
begin

    -- Your code here

end architecture;
