library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity penc32 is
    port (req : in std_logic_vector(31 downto 0); valid : out std_logic; idx : out std_logic_vector(4 downto 0));
end entity;

architecture rtl of penc32 is
    type v_t is array (natural range <>) of std_logic;
    type i_t is array (natural range <>) of unsigned(4 downto 0);
begin
    process (req)
        variable v : v_t(0 to 31);
        variable ix : i_t(0 to 31);
        variable n : natural;
    begin
        for k in 0 to 31 loop
            v(k) := req(k); ix(k) := (others => '0');
        end loop;
        n := 32;
        for lvl in 0 to 4 loop            -- pairwise reduction: log2(32) levels
            n := n / 2;
            for k in 0 to 15 loop
                if k < n then
                    if v(2*k) = '1' then
                        ix(k) := ix(2*k);
                    else
                        ix(k) := ix(2*k + 1);
                        ix(k)(lvl) := '1';
                    end if;
                    v(k) := v(2*k) or v(2*k + 1);
                end if;
            end loop;
        end loop;
        valid <= v(0);
        if v(0) = '1' then idx <= std_logic_vector(ix(0)); else idx <= (others => '0'); end if;
    end process;
end architecture;
