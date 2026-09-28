library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fu_tracker is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        issue    : in  std_logic;
        fu       : in  std_logic_vector(1 downto 0);
        latency  : in  std_logic_vector(2 downto 0);
        busy     : out std_logic_vector(3 downto 0);
        accepted : out std_logic
    );
end entity;

architecture rtl of fu_tracker is
    type cnt_t is array (0 to 3) of unsigned(2 downto 0);
    signal cnt : cnt_t := (others => (others => '0'));
begin
    g : for i in 0 to 3 generate
        busy(i) <= '1' when cnt(i) /= 0 else '0';
    end generate;

    process (clk)
        variable f  : natural range 0 to 3;
        variable ok : boolean;
    begin
        if rising_edge(clk) then
            f := to_integer(unsigned(fu));
            ok := issue = '1' and cnt(f) = 0 and unsigned(latency) /= 0;
            if rst = '1' then
                cnt <= (others => (others => '0'));
                accepted <= '0';
            else
                for i in 0 to 3 loop
                    if ok and i = f then
                        cnt(i) <= unsigned(latency);
                    elsif cnt(i) /= 0 then
                        cnt(i) <= cnt(i) - 1;
                    end if;
                end loop;
                if ok then accepted <= '1'; else accepted <= '0'; end if;
            end if;
        end if;
    end process;
end architecture;
