library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity drowsy_array is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        req     : in  std_logic;
        we      : in  std_logic;
        idx     : in  std_logic_vector(2 downto 0);
        wdata   : in  std_logic_vector(7 downto 0);
        ready   : out std_logic;
        rdata   : out std_logic_vector(7 downto 0);
        drowsy  : out std_logic_vector(7 downto 0);
        wakeups : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of drowsy_array is
    type mem_t is array (0 to 7) of std_logic_vector(7 downto 0);
    signal data : mem_t := (others => (others => '0'));
    signal dz   : std_logic_vector(7 downto 0) := (others => '1');
    signal cyc  : unsigned(3 downto 0) := (others => '0');
    signal wk   : unsigned(7 downto 0) := (others => '0');
begin
    drowsy <= dz;
    wakeups <= std_logic_vector(wk);
    process (clk)
        variable i : natural range 0 to 7;
        variable nd : std_logic_vector(7 downto 0);
    begin
        if rising_edge(clk) then
            i := to_integer(unsigned(idx));
            if rst = '1' then
                data <= (others => (others => '0')); dz <= (others => '1');
                cyc <= (others => '0'); wk <= (others => '0'); ready <= '0';
            else
                nd := dz;
                ready <= '0';
                if req = '1' then
                    if dz(i) = '1' then
                        nd(i) := '0'; wk <= wk + 1;
                    else
                        ready <= '1';
                        if we = '1' then data(i) <= wdata; else rdata <= data(i); end if;
                    end if;
                end if;
                if cyc = 15 then dz <= (others => '1'); else dz <= nd; end if;
                cyc <= cyc + 1;
            end if;
        end if;
    end process;
end architecture;
