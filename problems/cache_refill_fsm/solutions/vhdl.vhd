library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity refill_fsm is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        miss        : in  std_logic;
        dirty       : in  std_logic;
        miss_line   : in  std_logic_vector(7 downto 0);
        victim_line : in  std_logic_vector(7 downto 0);
        mem_ack     : in  std_logic;
        mem_req     : out std_logic;
        mem_we      : out std_logic;
        mem_addr    : out std_logic_vector(9 downto 0);
        done        : out std_logic
    );
end entity;

architecture rtl of refill_fsm is
    type state_t is (IDLE, WB, RF, DN);
    signal state  : state_t := IDLE;
    signal beat   : unsigned(1 downto 0) := "00";
    signal ml, vl : std_logic_vector(7 downto 0);
begin
    mem_req  <= '1' when state = WB or state = RF else '0';
    mem_we   <= '1' when state = WB else '0';
    mem_addr <= (vl & std_logic_vector(beat)) when state = WB else (ml & std_logic_vector(beat));
    done     <= '1' when state = DN else '0';

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= IDLE;
            else
                case state is
                    when IDLE =>
                        if miss = '1' then
                            ml <= miss_line; vl <= victim_line; beat <= "00";
                            if dirty = '1' then state <= WB; else state <= RF; end if;
                        end if;
                    when WB | RF =>
                        if mem_ack = '1' then
                            beat <= beat + 1;
                            if beat = 3 then
                                if state = WB then state <= RF; else state <= DN; end if;
                            end if;
                        end if;
                    when DN =>
                        state <= IDLE;
                end case;
            end if;
        end if;
    end process;
end architecture;
