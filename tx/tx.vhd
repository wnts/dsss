--------------------------------------------------
--! @file
--! @brief Datalink layer top module
--------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity dsss_tx is
	port(clk		: in std_logic;							--! Clock signaal
		 reset		: in std_logic;							--! rst
		 up			: in std_logic;							--! UP knop
		 down 		: in std_logic;							--! DOWN knop
		 sel		: in std_logic_vector(1 downto 0);		--! Psuedo-noise code selectie
		 segment	: out std_logic_vector(7 downto 0);		--! 7 segment output
		 sdo_spread	: out std_logic);		 				--! De als pn-codes geencodeerde data
end dsss_tx;

architecture behave of dsss_tx is
	-- declaraties van gebruikte componenten
	component application_layer is
		port(clk		: in std_logic;							--! Clock signaal
			 reset		: in std_logic;							--! rst
			 up			: in std_logic;							--! Signaal voor knop omhoog
			 down		: in std_logic;							--! Signalen voor knop omlaag
			 count		: out std_logic_vector(3 downto 0);		--! 4 bit data uitgang
			 segment	: out std_logic_vector(7 downto 0));	--! Zevensegment uitgang
	end component;
	component datalink_layer is
		port(clk		: in std_logic;							--! Clock signaal
			 reset		: in std_logic;							--! rst
			 pn_start	: in std_logic;							--! Psuedo-noise generator start puls
			 data		: in std_logic_vector(3 downto 0);		--! 4 bit data om te encoderen als pn-codes
			 sdo_posenc	: out std_logic);		 				--! De als pn-codes geencodeerde data
	end component;
	component access_layer is
		port(clk		: in std_logic;							--! Clock signaal
			 reset		: in std_logic;							--! rst
			 sdo_posenc	: in std_logic;
			 sel		: in std_logic_vector(1 downto 0);
			 pn_start	: out std_logic;
			 sdo_spread : out std_logic);		 
	end component;
	-- declaraties interne signalen
	signal count : std_logic_vector(3 downto 0);
	signal pn_start : std_logic;
	signal sdo_posenc : std_logic;
begin
	-- instantieren van componenten
	application_layer_inst : application_layer
		port map(clk		=> clk,
				 reset		=> reset,
				 up			=> up,
				 down		=> down,
				 count		=> count,
				 segment 	=> segment);
	datalink_layer_inst : datalink_layer
		port map(clk		=> clk,
				 reset		=> reset,
				 pn_start	=> pn_start,
				 data		=> count,
				 sdo_posenc => sdo_posenc);
	access_layer_inst : access_layer
		port map(clk		=> clk,
				 reset		=> reset,
				 sdo_posenc => sdo_posenc,
				 sel		=> sel,
				 pn_start	=> pn_start,
				 sdo_spread	=> sdo_spread);
end behave;
		