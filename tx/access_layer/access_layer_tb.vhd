library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity access_layer_tb is
end access_layer_tb;

architecture structural of access_layer_tb is 
	-- component declaraties
	component access_layer is
		port(clk		: in std_logic;							--! Clock signaal
			 reset		: in std_logic;							--! rst
			 sdo_posenc	: in std_logic;
			 sel		: in std_logic_vector(1 downto 0);
			 pn_start	: out std_logic;
			 sdo_spread : out std_logic);		 
	end component;
	component datalink_layer is
		port(clk		: in std_logic;							--! Clock signaal
			 reset		: in std_logic;							--! rst
			 pn_start	: in std_logic;							--! Psuedo-noise generator start puls
			 data		: in std_logic_vector(3 downto 0);		--! 4 bit data om te encoderen als pn-codes
			 sdo_posenc	: out std_logic);		 				--! De als pn-codes geencodeerde data
	end component;

	for uut : access_layer use entity work.access_layer(behave);
 
	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk			: std_logic;
	signal reset		: std_logic;
	signal sdo_posenc	: std_logic;
	signal sel			: std_logic_vector(1 downto 0);
	signal data			: std_logic_vector(3 downto 0) := "1001";
	signal pn_start 	: std_logic;
	signal sdo_spread 	: std_logic;


begin
	uut: access_layer
		port map(clk	 	 => clk,      
				 reset	 	 => reset,
				 sdo_posenc	 => sdo_posenc,
				 sel	  	 => sel,
				 pn_start	 =>	pn_start,
				 sdo_spread  => sdo_spread);
	datalink_layer_inst : datalink_layer
		port map(clk		=> clk,
				 reset		=> reset,
				 pn_start	=> pn_start,
				 data 		=> data,
				 sdo_posenc => sdo_posenc);
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
	--  Deze testbench test de access_layer door deze te verbinden
	--  met een instantie van de datalink_layer. Er wordt dan ter simulatie 1
	--  word data geencodeerd (preamble + inhoud van data ("1001"))
	-- *************************************************************************
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0))is
		begin	  
			reset 	   <= stimvect(2);
			sel		   <= stimvect(1 downto 0);			
		   wait for period;
		end tbvector;
	begin		
		-- *************
		-- *** Reset ***
		-- *************
		-- reset actief voor 2 clk periodes		
		tbvector("100");	
		tbvector("100");
		tbvector("100");	
		tbvector("100");
		-- 11 bits (1 word) versturen als 31 chip lange pn codes duurt 11*31 chip periods (chip periode = clk periode)
		for i in 1 to 11*31 loop
			-- Zet pn code selecctor op gold code
			tbvector("011");
		end loop;
		end_of_sim <= true;
		wait;
	end process;
end;

	
	
