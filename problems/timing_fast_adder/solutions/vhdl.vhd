library ieee;
use ieee.std_logic_1164.all;

entity fast_add16 is
    port (
        a    : in  std_logic_vector(15 downto 0);
        b    : in  std_logic_vector(15 downto 0);
        cin  : in  std_logic;
        s    : out std_logic_vector(15 downto 0);
        cout : out std_logic
    );
end entity;

-- Kogge-Stone parallel-prefix adder
architecture rtl of fast_add16 is
    type level_t is array (0 to 4) of std_logic_vector(15 downto 0);
    signal g, p : level_t;
    signal p0   : std_logic_vector(15 downto 0);
begin
    p0   <= a xor b;
    g(0) <= (a(15 downto 1) and b(15 downto 1)) & ((a(0) and b(0)) or (p0(0) and cin));
    p(0) <= p0;

    lv : for l in 1 to 4 generate
        bits : for i in 0 to 15 generate
            far : if i >= 2 ** (l - 1) generate
                g(l)(i) <= g(l-1)(i) or (p(l-1)(i) and g(l-1)(i - 2 ** (l - 1)));
                p(l)(i) <= p(l-1)(i) and p(l-1)(i - 2 ** (l - 1));
            end generate;
            near : if i < 2 ** (l - 1) generate
                g(l)(i) <= g(l-1)(i);
                p(l)(i) <= p(l-1)(i);
            end generate;
        end generate;
    end generate;

    s    <= p0 xor (g(4)(14 downto 0) & cin);
    cout <= g(4)(15);
end architecture;
