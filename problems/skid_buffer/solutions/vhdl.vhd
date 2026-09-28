library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity skid_buffer is
    port (clk, rst, in_valid : in std_logic; in_data : in std_logic_vector(7 downto 0);
          in_ready : out std_logic; out_valid : out std_logic; out_data : out std_logic_vector(7 downto 0);
          out_ready : in std_logic);
end entity;

architecture rtl of skid_buffer is
    signal ov, sv : std_logic := '0';
    signal od, sd : std_logic_vector(7 downto 0);
begin
    in_ready <= not sv;
    out_valid <= ov;
    out_data <= od;
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ov <= '0'; sv <= '0';
            elsif ov = '0' or out_ready = '1' then
                if sv = '1' then
                    od <= sd; ov <= '1'; sv <= '0';
                else
                    ov <= in_valid; od <= in_data;
                end if;
            elsif in_valid = '1' and sv = '0' then
                sv <= '1'; sd <= in_data;
            end if;
        end if;
    end process;
end architecture;
