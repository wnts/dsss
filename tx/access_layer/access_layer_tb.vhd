library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity access_layer_tb is
end access_layer_tb;

architecture structural of access_layer_tb is 


component access_layer is
	port(clk		: in std_logic;							--! Clock signaal
		 reset		: in std_logic;							--! rst
		 sdi		: in std_logic;
		 sel		: in std_logic_vector(1 downto 0);
		 pn_start	: out std_logic;
		 sdo_spread : out std_logic);		 
end component;

for uut : access_layer use entity work.access_layer(behave);
 
constant period		: time := 100 ns;
constant delay		: time :=  10 ns;
signal end_of_sim	: boolean := false;

signal clk			: std_logic;
signal reset		: std_logic;
signal sdi			: std_logic;
signal sel			: std_logic_vector(1 downto 0);
signal pn_start 	: std_logic;
signal sdo_spread 	: std_logic;


begin

	uut: access_layer
		port map(clk	 	 => clk,      
				 reset	 	 => reset,
				 sdi	 	 => sdi,
				 sel	  	 => sel,
				 pn_start	 =>	pn_start,
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
	
	-- ****************************************************************
	--  @TODO: deftige testbench schrijven voor access_layer
	-- ****************************************************************
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(4 downto 0))is
		begin	  
			reset 	  <= stimvect(4);
			pn_start  <= stimvect(3);   
			sdi   	  <= stimvect(2);
			sel		  <= stimvect(1 downto 0);			
		   wait for period;
		end tbvector;
	begin		
		-- *************
		-- *** Reset ***
		-- *************
		-- inputs uit fase met clk (meer realistisch voor gebruiker die op knoppen drukt (asynchroon))      	
		wait for delay; 
		-- reset actief voor 2 clk periodes		
		tbvector("11000");	
		tbvector("11000");
		-- ...		
		end_of_sim <= true;
		wait;
	end process;
end;



