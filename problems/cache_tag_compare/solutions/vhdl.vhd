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
    signal oh : std_logic_vector(3 downto 0);
begin
    g : for i in 0 to 3 generate
        oh(i) <= '1' when way_valid(i) = '1' and way_tags(20*i + 19 downto 20*i) = tag else '0';
    end generate;
    hit_onehot <= oh;
    hit <= or oh;
    multi_hit <= '1' when (unsigned(oh) and (unsigned(oh) - 1)) /= 0 else '0';
    hit_way <= "00" when oh(0) = '1' else
               "01" when oh(1) = '1' else
               "10" when oh(2) = '1' else
               "11" when oh(3) = '1' else "00";
end architecture;
