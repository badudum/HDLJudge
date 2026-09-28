library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        rx        : in  std_logic;
        data      : out std_logic_vector(7 downto 0);
        valid     : out std_logic;
        frame_err : out std_logic
    );
end entity;

architecture rtl of uart_rx is
    signal busy : std_logic := '0';
    signal k    : natural range 0 to 127 := 0;
    signal sh   : std_logic_vector(7 downto 0) := (others => '0');
begin
    process (clk)
        variable kn : natural range 0 to 128;
    begin
        if rising_edge(clk) then
            valid     <= '0';
            frame_err <= '0';
            kn := k + 1;
            if rst = '1' then
                busy <= '0';
                data <= (others => '0');
            elsif busy = '0' then
                if rx = '0' then
                    busy <= '1';
                    k    <= 0;
                end if;
            else
                k <= kn;
                if kn = 4 then
                    if rx = '1' then busy <= '0'; end if;
                elsif kn >= 12 and kn <= 68 and (kn - 12) mod 8 = 0 then
                    sh <= rx & sh(7 downto 1);
                elsif kn = 76 then
                    if rx = '1' then
                        data  <= sh;
                        valid <= '1';
                    else
                        frame_err <= '1';
                    end if;
                    busy <= '0';
                end if;
            end if;
        end if;
    end process;
end architecture;
