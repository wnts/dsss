library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	port(clk, reset : in std_logic;
	     up, down: in std_logic;
	     count: out std_logic_vector(3 downto 0));
end counter;

architecture behave of counter is
	signal cnt_cur, cnt_next : unsigned(3 downto 0);
begin
	syn_counter : process(clk)
	begin
		if reset = '1' then
			cnt_cur <= (others => '0');
		elsif rising_edge(clk) then
			cnt_cur <= cnt_next;
		end if;
	end process syn_counter;

	comb_counter : process(up, down, cnt_next, cnt_cur)
	begin
		if up = '1' then
			cnt_next <= cnt_cur + 1;
		elsif down = '1' then
			cnt_next <= cnt_cur - 1;
		else
			cnt_next <= cnt_cur;
		end if;
		count <= std_logic_vector(cnt_cur);
	end process comb_counter;
end behave;

				



		


