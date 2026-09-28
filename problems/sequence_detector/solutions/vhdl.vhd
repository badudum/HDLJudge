library ieee;
use ieee.std_logic_1164.all;

entity seq_detect is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        din      : in  std_logic;
        detected : out std_logic
    );
end entity;

architecture rtl of seq_detect is
    type state_t is (S0, S1, S10, S101, S1011);
    signal state : state_t := S0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= S0;
            else
                case state is
                    when S0    => if din = '1' then state <= S1;    else state <= S0;  end if;
                    when S1    => if din = '1' then state <= S1;    else state <= S10; end if;
                    when S10   => if din = '1' then state <= S101;  else state <= S0;  end if;
                    when S101  => if din = '1' then state <= S1011; else state <= S10; end if;
                    when S1011 => if din = '1' then state <= S1;    else state <= S10; end if;
                end case;
            end if;
        end if;
    end process;
    detected <= '1' when state = S1011 else '0';
end architecture;
