library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dsss_tx_tb is
end dsss_tx_tb;

architecture structural of dsss_tx_tb is 
	-- component declaraties
	component dsss_tx is
		port(clk		: in std_logic;							--! Clock signaal
			 reset		: in std_logic;							--! rst
			 up			: in std_logic;							--! UP knop
			 down 		: in std_logic;							--! DOWN knop
			 sel		: in std_logic_vector(1 downto 0);		--! Psuedo-noise code selectie
			 segment	: out std_logic_vector(7 downto 0);		--! 7 segment output
			 sdo_spread	: out std_logic);		 				--! De als pn-codes geencodeerde data
	end component;

	for uut : dsss_tx use entity work.dsss_tx(behave);
 
	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk			: std_logic;
	signal reset		: std_logic;
	signal sel			: std_logic_vector(1 downto 0);
	signal up, down		: std_logic;
	signal sdo_spread 	: std_logic;
	signal segment		: std_logic_vector(7 downto 0);


begin
	uut: dsss_tx
		port map(clk	 	 => clk,      
				 reset	 	 => reset,
				 up			 => up,
				 down		 => down,
				 sel		 => sel,
				 segment	 =>	segment,
				 sdo_spread  => sdo_spread);

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
	--  Deze testbench test de dsss_tx door deze te verbinden
	--  met een instantie van de datalink_layer. Er wordt dan ter simulatie 1
	--  word data geencodeerd (preamble + inhoud van data ("1001"))
	-- *************************************************************************
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(4 downto 0))is
		begin	  
			reset 	   <= stimvect(4);
			down	   <= stimvect(3);
			up		   <= stimvect(2);
			sel		   <= stimvect(1 downto 0);			
		   wait for period;
		end tbvector;
	begin		
		-- *************
		-- *** Reset ***
		-- *************
		-- inputs uit fase met clk (meer realistisch voor gebruiker die op knoppen drukt (asynchroon))      	
		wait for delay; 
		-- reset actief voor 2 clk periodes		
		tbvector("10000");	
		tbvector("10000");
		for i in 1 to 6 loop
			tbvector("00111");
		end loop;
		wait for period*1000;
		end_of_sim <= true;
		wait;
	end process;
end;

	
	