library ieee;
library dsss_rx;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity correlator_tb is
end correlator_tb;

architecture structural of correlator_tb is 
	-- component declaraties
	component correlator is
		port(clk			: in std_logic;	     		 
			 reset			: in std_logic;
			 chip_sample2	: in std_logic;
			 sdi_despread	: in std_logic;
			 bit_sample		: in std_logic;
			 databit		: out std_logic);
	end component;



for uut : correlator use entity dsss_rx.correlator(behave);
 
	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk			: std_logic;
	signal reset		: std_logic;
	signal chip_sample2	: std_logic;
	signal sdi_despread	: std_logic;
	signal bit_sample  	: std_logic;
	signal databit		: std_logic;
begin
	uut: correlator
		port map(clk	 	  => clk,      
				 reset		  => reset,
				 chip_sample2 => chip_sample2,
				 sdi_despread => sdi_despread,
				 bit_sample	  => bit_sample,
				 databit	  => databit);
	
	clock : process
	begin
		-- begin met halve periode laag voor loop, zodat stijgende flanken van de clock
		-- op veelvouden van de periode(in simulation time) vallen
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

	-- ***********************************************
	-- Genereer chip_sample2 puls elke 16 clk pulsen
	-- ***********************************************
	gen_chip_sample2 : process
	begin
		wait until rising_edge(clk);
		loop			
			chip_sample2 <= '1';
			wait for period;
			chip_sample2 <= '0';
			wait for period*15;			
			exit when end_of_sim;
		end loop;
		wait;
	end process gen_chip_sample2;
	-- ******************************************************
	-- Genereer bit_sample puls elke 31 chip_sample2 pulsen
	-- ******************************************************
	gen_bit_sample : process
	begin
		wait until rising_edge(chip_sample2);
		loop			
			bit_sample <= '1';
			wait for period;
			bit_sample <= '0';
			wait for period*31*16-period;			
			exit when end_of_sim;
		end loop;
		wait;
	end process gen_bit_sample;

	-- ************************************************************************
	--  Correlator testbench
	-- *************************************************************************
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
		begin	  
			reset <= stimvect(1);
			sdi_despread <= stimvect(0);
		   wait for period;
		end tbvector;
		variable testv0 : std_logic_vector(30 downto 0) 	:= "1000100100000100100010101010101"; -- 11 eenen, 20 nullen
		variable testv1 : std_logic_vector(30 downto 0) 	:= "1110011001110110111100010111111"; -- 21 eenen, 10 nullen
		variable testvrandgeval : std_logic_vector(30 downto 0) := "1001001000000101111111001111000"; -- 15 eenen, 16 nullen


	begin		
		-- reset
		reset <= '1';
		wait for period * 17;
		reset <= '0';
		-- propere volledgie 0 aanleggen
		for i in 30 downto 0 loop
			sdi_despread <= '0';
			wait for period * 16;
		end loop;
		-- propere volledige 1 aanleggen
		for i in 30 downto 0 loop
			sdi_despread <= '1';
			wait for period * 16;
		end loop;
		-- testv0 aanleggen
		for i in 30 downto 0 loop
			sdi_despread <= testv0(i);
			wait for period * 16;
		end loop;
		-- testv1 aanleggen
		for i in 30 downto 0 loop
			sdi_despread <= testv1(i);
			wait for period * 16;
		end loop;
		-- randgeval2: juist meer nullen dan eenen
		for i in 30 downto 0 loop
			sdi_despread <= testvrandgeval(i);
			wait for period * 16;
		end loop;
		-- randgeval1: juist meer eenen dan nullen
		for i in 30 downto 0 loop
			sdi_despread <= not testvrandgeval(i);
			wait for period * 16;
		end loop;
		-- tenslotte nog een propere nul aanleggen zodat we resultaat van vorige bit kunnen zien (er is altijd een bittijd delay)
		for i in 30 downto 0 loop
			sdi_despread <= '0';
			wait for period * 16;
		end loop;
		end_of_sim <= true;
		wait;
	end process;
end;

	
	