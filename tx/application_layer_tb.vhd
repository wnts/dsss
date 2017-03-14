library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity edge_detector_tb is
end edge_detector_tb;

architecture structural of edge_detector_tb is 


component application_layer is
	port(clk		: in std_logic;							
		 reset		: in std_logic;							
		 up			: in std_logic;							
		 down		: in std_logic;							
		 count		: out std_logic_vector(3 downto 0);		
		 segment	: out std_logic_vector(7 downto 0));	
end component;

for uut : application_layer use entity work.application_layer(behave);
 
constant period 	: time := 100 ns;
constant delay  	: time :=  10 ns;
signal end_of_sim 	: boolean := false;

signal clk 		: std_logic;
signal reset	: std_logic;
signal up, down	: std_logic;
signal count	: std_logic_vector(3 downto 0);
signal segment  : std_logic_vector(7 downto 0);

begin

	uut: application_layer
		port map(clk 	 => clk,      
				 reset	 => reset,
				 up 	 => up,
				 down 	 => down,
				 count	 => count,
				 segment => segment);
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
	
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
	    begin	  
		    up   <= stimvect(0);   
			down <= stimvect(1);
 	       wait for period;
	    end tbvector;
	begin
		wait for delay; -- inputs uit fase met clk (meer realistisch)      
		tbvector("10");
		tbvector("10");
		tbvector("10");
		tbvector("01");
		tbvector("01");
		tbvector("01");
		end_of_sim <= true;
		wait;
	end process;
end;




