library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rob8 is
    port (
        clk            : in  std_logic;
        rst            : in  std_logic;
        alloc_valid    : in  std_logic;
        alloc_rd       : in  std_logic_vector(4 downto 0);
        complete_valid : in  std_logic;
        complete_tag   : in  std_logic_vector(2 downto 0);
        complete_data  : in  std_logic_vector(15 downto 0);
        alloc_ok       : out std_logic;
        alloc_tag      : out std_logic_vector(2 downto 0);
        commit_valid   : out std_logic;
        commit_rd      : out std_logic_vector(4 downto 0);
        commit_data    : out std_logic_vector(15 downto 0);
        count          : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of rob8 is
    type rd_t is array (0 to 7) of std_logic_vector(4 downto 0);
    type data_t is array (0 to 7) of std_logic_vector(15 downto 0);
    signal valid, done : std_logic_vector(7 downto 0) := (others => '0');
    signal rd          : rd_t;
    signal data        : data_t;
    signal head, tail  : unsigned(2 downto 0) := "000";
    signal cnt         : natural range 0 to 8 := 0;
begin
    count <= std_logic_vector(to_unsigned(cnt, 4));
    process (clk)
        variable commit, alloc : boolean;
        variable h, t          : natural range 0 to 7;
        variable c             : natural range 0 to 8;
    begin
        if rising_edge(clk) then
            h := to_integer(head);
            t := to_integer(tail);
            commit := valid(h) = '1' and done(h) = '1';
            alloc  := alloc_valid = '1' and cnt /= 8;
            if rst = '1' then
                valid <= (others => '0'); done <= (others => '0');
                head <= "000"; tail <= "000"; cnt <= 0;
                alloc_ok <= '0'; commit_valid <= '0';
            else
                c := cnt;
                commit_valid <= '0';
                if commit then
                    commit_valid <= '1';
                    commit_rd <= rd(h);
                    commit_data <= data(h);
                end if;
                if complete_valid = '1' then
                    done(to_integer(unsigned(complete_tag))) <= '1';
                    data(to_integer(unsigned(complete_tag))) <= complete_data;
                end if;
                if commit then
                    valid(h) <= '0';
                    head <= head + 1;
                    c := c - 1;
                end if;
                alloc_ok <= '0';
                if alloc then
                    valid(t) <= '1';
                    done(t) <= '0';
                    rd(t) <= alloc_rd;
                    alloc_tag <= std_logic_vector(tail);
                    alloc_ok <= '1';
                    tail <= tail + 1;
                    c := c + 1;
                end if;
                cnt <= c;
            end if;
        end if;
    end process;
end architecture;
