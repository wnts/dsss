library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity datalink_layer_tb is
end datalink_layer_tb;

architecture structural of datalink_layer_tb is 


component datalink_layer is
	port(clk		: in std_logic;							
		 reset		: in std_logic;							
		 pn_start	: in std_logic;							
		 data		: in std_logic_vector(3 downto 0);		
		 sdo_posenc	: out std_logic);		 				
end component;

for uut : datalink_layer use entity work.datalink_layer(behave);
 
constant period		: time := 100 ns;
constant delay		: time :=  10 ns;
signal end_of_sim	: boolean := false;

signal clk			: std_logic;
signal reset		: std_logic;
signal pn_start	    : std_logic;
signal sdo_posenc	: std_logic;
signal data			: std_logic_vector(3 downto 0);


begin

	uut: datalink_layer
		port map(clk	 	 => clk,      
				 reset	 	 => reset,				
				 pn_start	 =>	pn_start,
				 data		 => data,
				 sdo_posenc  => sdo_posenc);
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
	--  @TODO: deftige testbench schrijven voor datalink_layer
    --  Maar is dit wel nodig? De datalink_layer doet niets anders dan
	--  componenten aan elkaar linken die allemaal getest worden in hun
	--  eigen testbench...
	-- ****************************************************************
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(4 downto 0))is
		begin	  
			reset 	  <= stimvect(4);
			data  	  <= stimvect(3 downto 0);   
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
		-- ...		
		end_of_sim <= true;
		wait;
	end process;
end;


