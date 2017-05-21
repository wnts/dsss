library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity universal_counter_tb is
end universal_counter_tb;

architecture structural of universal_counter_tb is 
	-- component declaraties
	component universal_counter is
		generic(N		: positive);
		port(clk		: in std_logic;		
			 reset		: in std_logic;
			 en			: in std_logic;	     		 
		     up			: in std_logic;
	         down		: in std_logic;
			 load		: in std_logic;		
			 data		: in std_logic_vector(N-1 downto 0);
			 count		: out std_logic_vector(N-1 downto 0);
			 max_tick	: out std_logic;
			 min_tick	: out std_logic);
	end component;

for uut : universal_counter use entity work.universal_counter(behave);
 
	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	-- bit breedte van geteste counter
	constant N			: positive := 3;
	signal end_of_sim	: boolean := false;

	signal clk			: std_logic;
	signal reset		: std_logic;	
	signal en			: std_logic := '1';     		 
	signal up			: std_logic;
	signal down			: std_logic;
	signal load			: std_logic;		
	signal data			: std_logic_vector(N-1 downto 0);
	signal count		: std_logic_vector(N-1 downto 0);
	signal max_tick		: std_logic;
	signal min_tick		: std_logic;
begin
	uut: universal_counter
		generic map(N 		 => N)
		port map(clk	 	 => clk,      
				 reset		 => reset,
				 en			 => en,
				 up			 => up,
				 down		 => down,
				 load		 => load,
				 data		 => data,
				 count		 => count,
				 min_tick	 => min_tick,
				 max_tick	 => max_tick);
	clock : process
	begin 
		clk <= '0';
		wait for period/2;
		loop
			clk <= '0';
			wait for period/2;
			clk <= '1';
			wait for period/2;
			exit when end_of_sim;
		end loop;
		wait;
	end process clock;
		
	-- ************************************************************************
	--  Universele counter testbench
	-- *************************************************************************
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(3 downto 0))is
		begin	  
			reset <= stimvect(3);
			up	  <= stimvect(2);
			down  <= stimvect(1);			
			load  <= stimvect(0);			
		   wait for period;
		end tbvector;
	begin		
		-- Reset
		tbvector("1000");
		tbvector("1000");
		-- counter up tot overflow om max_tick te testen
		for i in 0 to 2**N loop
			tbvector("0100");
		end loop;
		-- preload test
		tbvector("1000");
		data <= "100";
		wait for period;
		data <= "010";
		tbvector("0001");
		for i in 0 to 2**N loop
			tbvector("0010");
		end loop;
		-- enable test
		up <= '1';
		en <= '0';
		wait for period * 5;
		en <= '1';
		wait for period;
		en <= '0';
		wait for period * 5;
		en <= '1';
		wait for period;
		en <= '0';
		wait for period * 5;
		en <= '1';
		wait for period;
		en <= '0';
		end_of_sim <= true;
		wait;
	end process;
end;

	
	
