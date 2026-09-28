library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tag_compare is
    port (
        tag        : in  std_logic_vector(19 downto 0);
        way_tags   : in  std_logic_vector(79 downto 0);
        way_valid  : in  std_logic_vector(3 downto 0);
        hit        : out std_logic;
        hit_way    : out std_logic_vector(1 downto 0);
        hit_onehot : out std_logic_vector(3 downto 0);
        multi_hit  : out std_logic
    );
end entity;

architecture rtl of tag_compare is
begin

    -- Your code here

end architecture;
