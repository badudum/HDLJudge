library ieee;
use ieee.std_logic_1164.all;

entity det1101 is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        din   : in  std_logic;
        found : out std_logic
    );
end entity;

architecture rtl of det1101 is
    type state_t is (S0, S1, S11, S110, S1101);
    signal state, nxt : state_t := S0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then state <= S0; else state <= nxt; end if;
        end if;
    end process;

    process (state)
    begin
        case state is
            when S0    => if din = '1' then nxt <= S1;    else nxt <= S0;   end if;
            when S1    => if din = '1' then nxt <= S11;   else nxt <= S0;   end if;
            when S11   => if din = '1' then nxt <= S11;   else nxt <= S110; end if;
            when S110  => if din = '1' then nxt <= S1101; else nxt <= S0;   end if;
            when S1101 => if din = '1' then nxt <= S1;    else nxt <= S0;   end if;
        end case;
    end process;

    found <= '1' when state = S1101 else '0';
end architecture;
