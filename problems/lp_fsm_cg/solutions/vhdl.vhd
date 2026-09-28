library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cg_ctrl is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        req      : in  std_logic;
        force_on : in  std_logic;
        cg_en    : out std_logic;
        ready    : out std_logic;
        saved    : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of cg_ctrl is
    type state_t is (S_OFF, S_WAKE, S_ON);
    signal state : state_t := S_OFF;
    signal idle  : natural range 0 to 2 := 0;
    signal cnt   : unsigned(15 downto 0) := (others => '0');
begin
    cg_en <= '0' when state = S_OFF else '1';
    ready <= '1' when state = S_ON else '0';
    saved <= std_logic_vector(cnt);
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= S_OFF; idle <= 0; cnt <= (others => '0');
            else
                case state is
                    when S_OFF =>
                        cnt <= cnt + 1;
                        if req = '1' or force_on = '1' then state <= S_WAKE; end if;
                    when S_WAKE =>
                        state <= S_ON; idle <= 0;
                    when S_ON =>
                        if req = '1' or force_on = '1' then idle <= 0;
                        elsif idle = 2 then state <= S_OFF; idle <= 0;
                        else idle <= idle + 1;
                        end if;
                end case;
            end if;
        end if;
    end process;
end architecture;
