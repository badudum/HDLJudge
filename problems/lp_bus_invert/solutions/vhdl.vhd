library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bus_invert is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        valid   : in  std_logic;
        din     : in  std_logic_vector(7 downto 0);
        bus_q   : out std_logic_vector(7 downto 0);
        inv     : out std_logic;
        dout    : out std_logic_vector(7 downto 0);
        toggles : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of bus_invert is
    signal b   : std_logic_vector(7 downto 0) := (others => '0');
    signal i_q : std_logic := '0';
    signal tog : unsigned(15 downto 0) := (others => '0');

    function popcount(x : std_logic_vector) return natural is
        variable n : natural := 0;
    begin
        for k in x'range loop
            if x(k) = '1' then n := n + 1; end if;
        end loop;
        return n;
    end function;
begin
    bus_q <= b;
    inv <= i_q;
    dout <= not b when i_q = '1' else b;
    toggles <= std_logic_vector(tog);
    process (clk)
        variable nb : std_logic_vector(7 downto 0);
        variable ni : std_logic;
        variable t  : natural;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                b <= (others => '0'); i_q <= '0'; tog <= (others => '0');
            elsif valid = '1' then
                if popcount(din xor b) > 4 then nb := not din; ni := '1'; else nb := din; ni := '0'; end if;
                t := popcount(nb xor b);
                if ni /= i_q then t := t + 1; end if;
                tog <= tog + t;
                b <= nb; i_q <= ni;
            end if;
        end if;
    end process;
end architecture;
