library ieee;
use ieee.std_logic_1164.all;

entity sar_ctrl is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        start  : in  std_logic;
        cmp    : in  std_logic;
        dac    : out std_logic_vector(7 downto 0);
        done   : out std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of sar_ctrl is
    signal code : std_logic_vector(7 downto 0) := (others => '0');
    signal busy : std_logic := '0';
    signal bitn : natural range 0 to 7 := 7;
begin
    dac <= code;
    process (clk)
        variable nxt : std_logic_vector(7 downto 0);
    begin
        if rising_edge(clk) then
            done <= '0';
            if rst = '1' then
                busy   <= '0';
                code   <= (others => '0');
                result <= (others => '0');
            elsif busy = '0' then
                if start = '1' then
                    busy <= '1';
                    code <= x"80";
                    bitn <= 7;
                end if;
            else
                nxt := code;
                if cmp = '0' then nxt(bitn) := '0'; end if;
                if bitn /= 0 then nxt(bitn - 1) := '1'; end if;
                code <= nxt;
                if bitn = 0 then
                    busy   <= '0';
                    done   <= '1';
                    result <= nxt;
                else
                    bitn <= bitn - 1;
                end if;
            end if;
        end if;
    end process;
end architecture;
