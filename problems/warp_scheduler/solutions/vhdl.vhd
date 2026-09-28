library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity warp_sched is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        ready       : in  std_logic_vector(3 downto 0);
        issue_valid : out std_logic;
        issue_warp  : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of warp_sched is
    type blk_t is array (0 to 3) of natural range 0 to 2;
    signal blk : blk_t := (others => 0);
    signal ptr   : unsigned(1 downto 0) := "00";
begin
    process (clk)
        variable w     : unsigned(1 downto 0);
        variable found : boolean;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ptr <= "00";
                blk <= (others => 0);
                issue_valid <= '0';
            else
                found := false;
                w := ptr;
                for k in 0 to 3 loop
                    if not found and ready(to_integer(ptr + k)) = '1' and blk(to_integer(ptr + k)) = 0 then
                        found := true;
                        w := ptr + k;
                    end if;
                end loop;
                for i in 0 to 3 loop
                    if found and i = to_integer(w) then
                        blk(i) <= 2;
                    elsif blk(i) /= 0 then
                        blk(i) <= blk(i) - 1;
                    end if;
                end loop;
                if found then
                    issue_valid <= '1';
                    issue_warp  <= std_logic_vector(w);
                    ptr <= w + 1;
                else
                    issue_valid <= '0';
                end if;
            end if;
        end if;
    end process;
end architecture;
