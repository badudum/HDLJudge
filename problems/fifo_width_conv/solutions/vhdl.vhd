library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity width_conv is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        in_valid  : in  std_logic;
        in_data   : in  std_logic_vector(7 downto 0);
        in_ready  : out std_logic;
        out_valid : out std_logic;
        out_data  : out std_logic_vector(31 downto 0);
        out_ready : in  std_logic
    );
end entity;

architecture rtl of width_conv is
    signal cnt : natural range 0 to 3 := 0;
    signal acc : std_logic_vector(23 downto 0) := (others => '0');
    signal ov  : std_logic := '0';
    signal rdy : std_logic;
begin
    rdy <= (not ov) or out_ready;
    in_ready <= rdy;
    out_valid <= ov;
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= 0; acc <= (others => '0'); ov <= '0';
            else
                if ov = '1' and out_ready = '1' then ov <= '0'; end if;
                if in_valid = '1' and rdy = '1' then
                    if cnt = 3 then
                        out_data <= in_data & acc;
                        ov <= '1';
                        acc <= (others => '0');
                        cnt <= 0;
                    else
                        acc(8*cnt + 7 downto 8*cnt) <= in_data;
                        cnt <= cnt + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture;
