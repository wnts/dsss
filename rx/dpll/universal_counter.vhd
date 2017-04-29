library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity universal_counter is
	generic(N		: positive);
	port(clk		: in std_logic;
		 reset		: in std_logic;	     		 
	     up			: in std_logic;
         down		: in std_logic;
		 load		: in std_logic;		
		 data		: in std_logic_vector(N-1 downto 0);
		 count		: out std_logic_vector(N-1 downto 0);
		 max_tick	: out std_logic;
		 min_tick	: out std_logic);
end universal_counter;

architecture behave of universal_counter is	
	signal present_count, next_count : unsigned(N-1 downto 0);
begin
	syn_universal_counter : process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then	
				present_count <= (others => '0');
			else
				present_count <= next_count;
			end if;
		end if;
	end process syn_universal_counter;
	
	com_universal_counter : process(up, down, load, present_count)
	begin
		-- next_count
		if load = '1' then
			next_count <= unsigned(data);
		elsif up = '1' then
			next_count <= present_count + 1;
		elsif down = '1' then
			next_count <= present_count - 1;
		else
			next_count <= present_count;
		end if;

		-- outputs
		if up = '1' and present_count = (2**N)-1 then
			max_tick <= '1';
		else
			max_tick <= '0';
		end if;
		if down = '1' and present_count = 0 then
			min_tick <= '1';
		else
			min_tick <= '0';
		end if;

		count <= std_logic_vector(present_count);		
	end process com_universal_counter;
end behave;