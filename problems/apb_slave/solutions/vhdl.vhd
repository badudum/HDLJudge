library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity apb_slave is
    port (
        pclk    : in  std_logic;
        presetn : in  std_logic;
        psel    : in  std_logic;
        penable : in  std_logic;
        pwrite  : in  std_logic;
        paddr   : in  std_logic_vector(7 downto 0);
        pwdata  : in  std_logic_vector(31 downto 0);
        pstrb   : in  std_logic_vector(3 downto 0);
        prdata  : out std_logic_vector(31 downto 0);
        pready  : out std_logic;
        pslverr : out std_logic
    );
end entity;

architecture rtl of apb_slave is
    constant ID : std_logic_vector(31 downto 0) := x"A9B00001";
    signal ctrl, data : std_logic_vector(31 downto 0) := (others => '0');
    signal wcount     : unsigned(31 downto 0) := (others => '0');
    signal access_ph, mapped, ro, bad : std_logic;
begin
    access_ph <= psel and penable;
    mapped <= '1' when paddr(1 downto 0) = "00" and unsigned(paddr) <= 12 else '0';
    ro <= '1' when paddr = x"08" or paddr = x"0C" else '0';
    bad <= (not mapped) or (pwrite and ro);
    pready <= '1';
    pslverr <= access_ph and bad;

    process (all)
    begin
        prdata <= (others => '0');
        if psel = '1' and pwrite = '0' and paddr(1 downto 0) = "00" then
            case paddr is
                when x"00" => prdata <= ctrl;
                when x"04" => prdata <= data;
                when x"08" => prdata <= ID;
                when x"0C" => prdata <= std_logic_vector(wcount);
                when others => null;
            end case;
        end if;
    end process;

    process (pclk)
    begin
        if rising_edge(pclk) then
            if presetn = '0' then
                ctrl <= (others => '0'); data <= (others => '0'); wcount <= (others => '0');
            elsif access_ph = '1' and pwrite = '1' and bad = '0' then
                for i in 0 to 3 loop
                    if pstrb(i) = '1' then
                        if paddr = x"00" then ctrl(8*i + 7 downto 8*i) <= pwdata(8*i + 7 downto 8*i);
                        else data(8*i + 7 downto 8*i) <= pwdata(8*i + 7 downto 8*i);
                        end if;
                    end if;
                end loop;
                wcount <= wcount + 1;
            end if;
        end if;
    end process;
end architecture;
