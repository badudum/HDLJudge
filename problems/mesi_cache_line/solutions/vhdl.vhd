library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mesi_line is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        pr_rd     : in  std_logic;
        pr_wr     : in  std_logic;
        bus_rd    : in  std_logic;
        bus_rdx   : in  std_logic;
        shared_in : in  std_logic;
        state     : out std_logic_vector(1 downto 0);
        wb        : out std_logic
    );
end entity;

architecture rtl of mesi_line is
    constant I : std_logic_vector(1 downto 0) := "00";
    constant S : std_logic_vector(1 downto 0) := "01";
    constant E : std_logic_vector(1 downto 0) := "10";
    constant M : std_logic_vector(1 downto 0) := "11";
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= I;
                wb    <= '0';
            else
                wb <= '0';
                if pr_rd = '1' then
                    if state = I then
                        if shared_in = '1' then
                            state <= S;
                        else
                            state <= E;
                        end if;
                    end if;
                elsif pr_wr = '1' then
                    state <= M;
                elsif bus_rd = '1' then
                    if state = M then
                        wb    <= '1';
                        state <= S;
                    elsif state = E then
                        state <= S;
                    end if;
                elsif bus_rdx = '1' then
                    if state = M then
                        wb <= '1';
                    end if;
                    state <= I;
                end if;
            end if;
        end if;
    end process;
end architecture;
