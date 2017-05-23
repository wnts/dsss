library ieee;
library dsss_rx;
library dsss_tx;
use ieee.std_logic_1164.all;

-- Topmodule van de ontvanger
-- Op dit moment verbindt deze module de rx access_layer met het data_shifregister en de data_latch
entity dsss_rx is
	port(clk			: in std_logic;	     		 
		 reset			: in std_logic;
		 rx_baseband	: in std_logic;
		 sel			: in std_logic_vector(1 downto 0));	
end dsss_rx;

architecture behave of dsss_rx is		
	-- component declaraties
	component access_layer is
		port(clk			: in std_logic;	     		 
			 reset			: in std_logic;
			 rx_baseband	: in std_logic;
			 sel			: in std_logic_vector(1 downto 0);
			 bit_sample		: out std_logic;
			 databit		: out std_logic);
	end component;
	component data_shiftregister is
		generic(N		: positive);
		port(clk		: in std_logic;
			 ce			: in std_logic;
			 reset		: in std_logic;	     		 
			 b			: in std_logic;	
			 data		: out std_logic_vector(N-1 downto 0));
	end component;
	component data_latch is
		port(clk		: in std_logic;
			 ce			: in std_logic;
			 preamble	: in std_logic_vector(6 downto 0);
			 data_in	: in std_logic_vector(3 downto 0);
			 data_out	: out std_logic_vector(3 downto 0));
	end component;
	-- interne signaal declaraties
	signal bit_sample, databit : std_logic;
	-- signaal voor verbinden van data_shiftregister met data_latch
	signal data_tmp : std_logic_vector(10 downto 0);
	-- uiteindelijke output signaal
	signal data_out: std_logic_vector(3 downto 0);
begin
	-- componenten instantieren
	access_layer_rx_inst : access_layer
		port map(clk		  => clk,
				 reset		  => reset,
				 rx_baseband  => rx_baseband,
				 sel		  => sel,
				 bit_sample	  => bit_sample,
				 databit	  => databit);
	data_shiftregister_inst : data_shiftregister
		generic map(N => 11)
		port map(clk		  => clk,
				 ce			  => bit_sample,
				 reset		  => reset,
				 b			  => databit,
				 data		  => data_tmp);
	data_latch_inst : data_latch
		port map(clk		  => clk,
				 ce			  => bit_sample,
				 preamble	  => data_tmp(10 downto 4),
				 data_in	  => data_tmp(3 downto 0),
				 data_out	  => data_out);
	
end behave;