library ieee;
use ieee.std_logic_1164.all;

entity onehot_fsm is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        go    : in  std_logic;
        done  : in  std_logic;
        state : out std_logic_vector(3 downto 0);
        busy  : out std_logic
    );
end entity;

architecture rtl of onehot_fsm is
    constant IDLE : natural := 0;
    constant LOAD : natural := 1;
    constant RUN  : natural := 2;
    constant FLSH : natural := 3;
    signal s, n : std_logic_vector(3 downto 0);
begin
    n(IDLE) <= (s(IDLE) and not go) or s(FLSH);
    n(LOAD) <= s(IDLE) and go;
    n(RUN)  <= s(LOAD) or s(RUN);
    n(FLSH) <= s(RUN) and done;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then s <= "0000"; else s <= n; end if;
        end if;
    end process;

    state <= s;
    busy <= not s(IDLE);
end architecture;
