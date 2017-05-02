library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity transition_detector_tb is
end transition_detector_tb;

architecture structural of transition_detector_tb is 
	-- component declaraties
	component transition_detector is
		port(clk		: in std_logic;	     		 
		     sdi_spread	: in std_logic;
	         exTB		: out std_logic);
	end component;

	for uut : transition_detector use entity work.transition_detector(behave);
 
	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk			: std_logic;
	signal exTB			: std_logic;
	signal sdi_spread	: std_logic;



begin
	uut: transition_detector
		port map(clk	 	 => clk,      
				 sdi_spread	 => sdi_spread,
				 exTB		 => exTB);
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
	--  Transition detector testbench
	-- *************************************************************************
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(0 downto 0))is
		begin	  
			sdi_spread <= stimvect(0);			
		   wait for period;
		end tbvector;
	begin		
		-- *************
		-- *** Reset ***
		-- *************
		-- simuleer aantal transities
		tbvector("0");
		tbvector("0");
		tbvector("0");
		tbvector("0");
		tbvector("0");
		tbvector("0");
		tbvector("1");
		tbvector("1");
		tbvector("1");
		tbvector("1");
		tbvector("1");
		tbvector("0");
		tbvector("0");
		tbvector("0");
		tbvector("0");
		tbvector("0");
		tbvector("0");
		tbvector("1");
		tbvector("1");
		tbvector("1");
		tbvector("1");
		tbvector("1");
		end_of_sim <= true;
		wait;
	end process;
end;

	
	

