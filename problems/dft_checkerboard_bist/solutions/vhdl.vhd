library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cb_bist is
    port (clk, rst, start : in std_logic; mem_rdata : in std_logic_vector(7 downto 0);
          mem_addr : out std_logic_vector(3 downto 0); mem_we : out std_logic; mem_wdata : out std_logic_vector(7 downto 0);
          busy, done, fail : out std_logic);
end entity;

architecture rtl of cb_bist is
    signal k : unsigned(5 downto 0) := (others => '0');
    signal b : std_logic := '0';
    function pat(kk : unsigned(5 downto 0)) return std_logic_vector is
        variable p : std_logic_vector(7 downto 0);
    begin
        if (kk(2) xor kk(0)) = '1' then p := x"AA"; else p := x"55"; end if;
        if kk(5) = '1' then p := not p; end if;
        return p;
    end function;
begin
    busy <= b;
    process (clk)
        variable kn : unsigned(5 downto 0);
    begin
        if rising_edge(clk) then
            done <= '0';
            if rst = '1' then
                b <= '0'; k <= (others => '0'); fail <= '0'; mem_we <= '0';
            elsif b = '1' then
                if k(4) = '1' and mem_rdata /= pat(k) then fail <= '1'; end if;
                kn := k + 1;
                k <= kn;
                if k = 63 then
                    b <= '0'; done <= '1'; mem_we <= '0';
                else
                    mem_addr <= std_logic_vector(kn(3 downto 0)); mem_we <= not kn(4); mem_wdata <= pat(kn);
                end if;
            elsif start = '1' then
                b <= '1'; k <= (others => '0'); fail <= '0';
                mem_addr <= "0000"; mem_we <= '1'; mem_wdata <= x"55";
            end if;
        end if;
    end process;
end architecture;
