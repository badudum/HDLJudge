library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        start : in  std_logic;
        data  : in  std_logic_vector(7 downto 0);
        tx    : out std_logic;
        busy  : out std_logic
    );
end entity;

architecture rtl of uart_tx is
    signal sh     : std_logic_vector(9 downto 0) := (others => '1');
    signal tick   : natural range 0 to 3 := 0;
    signal bitn   : natural range 0 to 9 := 0;
    signal busy_r : std_logic := '0';
begin
    busy <= busy_r;
    tx   <= sh(0) when busy_r = '1' else '1';

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                busy_r <= '0';
            elsif busy_r = '1' then
                if tick = 3 then
                    tick <= 0;
                    sh   <= '1' & sh(9 downto 1);
                    if bitn = 9 then busy_r <= '0'; else bitn <= bitn + 1; end if;
                else
                    tick <= tick + 1;
                end if;
            elsif start = '1' then
                sh     <= '1' & data & '0';
                busy_r <= '1';
                tick   <= 0;
                bitn   <= 0;
            end if;
        end if;
    end process;
end architecture;
