library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seq_div is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        start     : in  std_logic;
        dividend  : in  std_logic_vector(15 downto 0);
        divisor   : in  std_logic_vector(15 downto 0);
        busy      : out std_logic;
        done      : out std_logic;
        quotient  : out std_logic_vector(15 downto 0);
        remainder : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of seq_div is
    signal rm, num, den, q : unsigned(15 downto 0);
    signal step            : natural range 0 to 15;
    signal busy_r          : std_logic := '0';
begin
    busy <= busy_r;
    process (clk)
        variable sh, diff : unsigned(16 downto 0);
        variable rn, qn   : unsigned(15 downto 0);
    begin
        if rising_edge(clk) then
            done <= '0';
            if rst = '1' then
                busy_r <= '0';
                quotient <= (others => '0');
                remainder <= (others => '0');
            elsif busy_r = '1' then
                sh := rm & num(15);
                diff := sh - ('0' & den);
                if diff(16) = '0' then
                    rn := diff(15 downto 0); qn := q(14 downto 0) & '1';
                else
                    rn := sh(15 downto 0);   qn := q(14 downto 0) & '0';
                end if;
                rm <= rn; q <= qn;
                num <= shift_left(num, 1);
                if step = 15 then
                    busy_r <= '0'; done <= '1';
                    quotient <= std_logic_vector(qn);
                    remainder <= std_logic_vector(rn);
                else
                    step <= step + 1;
                end if;
            elsif start = '1' then
                busy_r <= '1';
                rm <= (others => '0'); q <= (others => '0');
                num <= unsigned(dividend); den <= unsigned(divisor);
                step <= 0;
            end if;
        end if;
    end process;
end architecture;
