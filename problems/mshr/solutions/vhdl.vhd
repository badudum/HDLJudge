library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mshr4 is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        miss_valid : in  std_logic;
        miss_addr  : in  std_logic_vector(7 downto 0);
        resp_valid : in  std_logic;
        resp_id    : in  std_logic_vector(1 downto 0);
        mem_req    : out std_logic;
        mem_id     : out std_logic_vector(1 downto 0);
        mem_addr   : out std_logic_vector(7 downto 0);
        merged     : out std_logic;
        merge_id   : out std_logic_vector(1 downto 0);
        stall      : out std_logic;
        valid_mask : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of mshr4 is
    type addr_t is array (0 to 3) of std_logic_vector(7 downto 0);
    signal addr : addr_t;
    signal vm   : std_logic_vector(3 downto 0) := "0000";
begin
    valid_mask <= vm;
    process (clk)
        variable v              : std_logic_vector(3 downto 0);
        variable hit, has_free  : boolean;
        variable hid, fid       : natural range 0 to 3;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                vm <= "0000";
                mem_req <= '0'; merged <= '0'; stall <= '0';
            else
                v := vm;
                if resp_valid = '1' then v(to_integer(unsigned(resp_id))) := '0'; end if;
                hit := false; has_free := false; hid := 0; fid := 0;
                for i in 3 downto 0 loop
                    if v(i) = '1' and addr(i) = miss_addr then hit := true; hid := i; end if;
                    if v(i) = '0' then has_free := true; fid := i; end if;
                end loop;
                mem_req <= '0'; merged <= '0'; stall <= '0';
                if miss_valid = '1' then
                    if hit then
                        merged <= '1'; merge_id <= std_logic_vector(to_unsigned(hid, 2));
                    elsif has_free then
                        mem_req <= '1';
                        mem_id <= std_logic_vector(to_unsigned(fid, 2));
                        mem_addr <= miss_addr;
                        addr(fid) <= miss_addr;
                        v(fid) := '1';
                    else
                        stall <= '1';
                    end if;
                end if;
                vm <= v;
            end if;
        end if;
    end process;
end architecture;
