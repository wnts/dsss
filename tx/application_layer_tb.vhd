library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity application_layer_tb is
end application_layer_tb;

architecture structural of application_layer_tb is 


component application_layer is
	port(clk		: in std_logic;							
		 reset		: in std_logic;							
		 up			: in std_logic;							
		 down		: in std_logic;							
		 count		: out std_logic_vector(3 downto 0);		
		 segment	: out std_logic_vector(7 downto 0));	
end component;

for uut : application_layer use entity work.application_layer(behave);
 
constant period		: time := 100 ns;
constant delay		: time :=  10 ns;
signal end_of_sim	: boolean := false;

signal clk		: std_logic;
signal reset	: std_logic := '0';
signal up, down	: std_logic;
signal count	: std_logic_vector(3 downto 0) := (others => '0');
signal segment  : std_logic_vector(7 downto 0) := (others => '0');

begin

	uut: application_layer
		port map(clk	 => clk,      
				 reset	 => reset,
				 up		 => up,
				 down	 => down,
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
	
	-- ****************************************************************
	-- (In deze tb wordt de application als black box getest, voor
	--  de correcte werking van de individuele interne componenten, zie
	--  de tb's horende bij deze componenten)
	-- Simuleer 5x druk op UP knop gevolgd door 5x druk op DOWN knop
	-- ****************************************************************
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0))is
		begin	  
			reset <= stimvect(2);
			up   <= stimvect(1);   
			down <= stimvect(0);
		   wait for period;
		end tbvector;
	begin		
		-- *************
		-- *** Reset ***
		-- *************
		-- inputs uit fase met clk (meer realistisch voor gebruiker die op knoppen drukt (asynchroon))      	
		wait for delay; 
		-- reset actief voor 2 clk periodes		
		tbvector("110");	
		tbvector("110");		
		-- *****************************************
		-- *** simuleer 5x indrukken van UP knop ***
		-- *****************************************
		for i in 1 to 5 loop	
			-- 5 klokcycli lang de knop 'ingedrukt' houden om door de debouncer te geraken
			for i in 1 to 6 loop	
			  tbvector("010"); 	
		    end loop;
			-- 5 klokcycli lang de knop 'loslaten' om door de debouncer te geraken 
			-- om vervolgens (volgende iteratie) opnieuwe een rising edge te maken
			for i in 1 to 6 loop	
			  tbvector("000"); 	
		    end loop;
		end loop;
		-- *****************************************
		-- *** simuleer 5x indrukken van DOWN knop ***
		-- *****************************************
		for i in 1 to 5 loop	
			-- 5 klokcycli lang de knop 'ingedrukt' houden om door de debouncer te geraken
			for i in 1 to 6 loop	
			  tbvector("001"); 	
		    end loop;
			-- 5 klokcycli lang de knop 'loslaten' om door de debouncer te geraken 
			-- om vervolgens (volgende iteratie) opnieuwe een rising edge te maken
			for i in 1 to 6 loop	
			  tbvector("000"); 	
		    end loop;
		end loop;

		end_of_sim <= true;
		wait;
	end process;
end;




