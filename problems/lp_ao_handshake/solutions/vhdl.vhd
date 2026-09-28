library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ao_ctrl is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        sleep_req : in  std_logic;
        wake_irq  : in  std_logic;
        pmu_ack   : in  std_logic;
        pmu_req   : out std_logic;
        asleep    : out std_logic;
        irq_out   : out std_logic
    );
end entity;

architecture rtl of ao_ctrl is
    type state_t is (S_RUN, S_REQ_OFF, S_SLEEP, S_REQ_ON);
    signal state : state_t := S_RUN;
    signal pend  : std_logic := '0';
begin
    pmu_req <= '1' when state = S_REQ_OFF or state = S_SLEEP else '0';
    asleep  <= '1' when state = S_SLEEP else '0';
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= S_RUN; pend <= '0'; irq_out <= '0';
            else
                irq_out <= '0';
                case state is
                    when S_RUN =>
                        if wake_irq = '1' then irq_out <= '1';
                        elsif sleep_req = '1' then state <= S_REQ_OFF;
                        end if;
                    when S_REQ_OFF =>
                        if wake_irq = '1' then pend <= '1'; end if;
                        if pmu_ack = '1' then
                            if pend = '1' or wake_irq = '1' then state <= S_REQ_ON; else state <= S_SLEEP; end if;
                        end if;
                    when S_SLEEP =>
                        if wake_irq = '1' then state <= S_REQ_ON; pend <= '1'; end if;
                    when S_REQ_ON =>
                        if pmu_ack = '0' then
                            state <= S_RUN; irq_out <= pend or wake_irq; pend <= '0';
                        elsif wake_irq = '1' then
                            pend <= '1';
                        end if;
                end case;
            end if;
        end if;
    end process;
end architecture;
