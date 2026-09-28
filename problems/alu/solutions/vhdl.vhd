library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity alu is
    generic (
        WIDTH : positive := 8
    );
    port (
        a        : in  std_logic_vector(WIDTH-1 downto 0);
        b        : in  std_logic_vector(WIDTH-1 downto 0);
        op       : in  std_logic_vector(3 downto 0);
        y        : out std_logic_vector(WIDTH-1 downto 0);
        zero     : out std_logic;
        carry    : out std_logic;
        overflow : out std_logic;
        negative : out std_logic
    );
end entity;

architecture rtl of alu is
    constant SW : natural := natural(ceil(log2(real(WIDTH))));
begin
    process (a, b, op)
        variable ua, ub, bb : unsigned(WIDTH-1 downto 0);
        variable sum        : unsigned(WIDTH downto 0);
        variable r          : unsigned(WIDTH-1 downto 0);
        variable sh         : natural;
        variable c, v       : std_logic;
    begin
        ua := unsigned(a);
        ub := unsigned(b);
        sh := to_integer(ub(SW-1 downto 0));
        if op = "0001" then bb := not ub; else bb := ub; end if;
        if op = "0001" then
            sum := ('0' & ua) + ('0' & bb) + 1;
        else
            sum := ('0' & ua) + ('0' & bb);
        end if;
        c := '0'; v := '0';
        case to_integer(unsigned(op)) is
            when 0 | 1 =>
                r := sum(WIDTH-1 downto 0);
                c := sum(WIDTH);
                if ua(WIDTH-1) = bb(WIDTH-1) and r(WIDTH-1) /= ua(WIDTH-1) then v := '1'; end if;
            when 2 => r := ua and ub;
            when 3 => r := ua or ub;
            when 4 => r := ua xor ub;
            when 5 => r := not (ua or ub);
            when 6 => r := shift_left(ua, sh);
            when 7 => r := shift_right(ua, sh);
            when 8 => r := unsigned(shift_right(signed(ua), sh));
            when 9 =>
                r := (others => '0');
                if signed(ua) < signed(ub) then r(0) := '1'; end if;
            when 10 =>
                r := (others => '0');
                if ua < ub then r(0) := '1'; end if;
            when others => r := (others => '0');
        end case;
        y <= std_logic_vector(r);
        carry <= c;
        overflow <= v;
        if r = 0 then zero <= '1'; else zero <= '0'; end if;
        negative <= r(WIDTH-1);
    end process;
end architecture;
