library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seq_mult is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        start   : in  std_logic;
        a       : in  std_logic_vector(7 downto 0);
        b       : in  std_logic_vector(7 downto 0);
        busy    : out std_logic;
        done    : out std_logic;
        product : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of seq_mult is
    signal acc, mcand : unsigned(15 downto 0);
    signal mplier     : unsigned(7 downto 0);
    signal step       : natural range 0 to 7;
    signal busy_r     : std_logic := '0';
begin
    busy <= busy_r;
    process (clk)
        variable nxt : unsigned(15 downto 0);
    begin
        if rising_edge(clk) then
            done <= '0';
            if rst = '1' then
                busy_r  <= '0';
                product <= (others => '0');
            elsif busy_r = '1' then
                if mplier(0) = '1' then nxt := acc + mcand; else nxt := acc; end if;
                acc    <= nxt;
                mcand  <= shift_left(mcand, 1);
                mplier <= shift_right(mplier, 1);
                if step = 7 then
                    busy_r  <= '0';
                    done    <= '1';
                    product <= std_logic_vector(nxt);
                else
                    step <= step + 1;
                end if;
            elsif start = '1' then
                busy_r <= '1';
                acc    <= (others => '0');
                mcand  <= resize(unsigned(a), 16);
                mplier <= unsigned(b);
                step   <= 0;
            end if;
        end if;
    end process;
end architecture;
