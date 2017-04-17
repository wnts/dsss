--------------------------------------------------
--! @file
--! @brief Datalink layer top module
--------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity datalink_layer is
	port(clk		: in std_logic;							--! Clock signaal
		 reset		: in std_logic;							--! rst
		 pn_start	: in std_logic;							--! Psuedo-noise generator start puls
		 data		: in std_logic_vector(3 downto 0);		--! 4 bit data om te encoderen als pn-codes
		 sdo_posenc	: out std_logic);		 				--! De als pn-codes geencodeerde data
end datalink_layer;

architecture behave of datalink_layer is
	-- declaraties van gebruikte componenten
	component dataregister is
		port(clk		: in std_logic;
			 ld			: in std_logic;
			 sh			: in std_logic;
			 data		: in std_logic_vector(3 downto 0);
			 sdo_posenc : out std_logic);
	end component;
	component sequence_controller is
		port(clk 		: in std_logic;
			 reset		: in std_logic;
			 pn_start 	: in std_logic;
			 ld			: out std_logic;
			 sh			: out std_logic);
	end component;
	-- declaraties interne signalen
	signal ld, sh : std_logic;
begin
	sequence_controller_inst : sequence_controller
		port map(clk	  => clk,
				 reset	  => reset,				 
				 pn_start => pn_start,
				 ld		  => ld,
    			 sh		  => sh);
	dataregister_inst : dataregister
		port map(clk 	    => clk,
				 ld 	    => ld,
				 sh		    => sh,
				 data	    => data,
				 sdo_posenc => sdo_posenc);
end behave;
		