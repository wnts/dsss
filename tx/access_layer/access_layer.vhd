--------------------------------------------------
--! @file
--! @brief Access layer top module
--------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity access_layer is
	port(clk		: in std_logic;							--! Clock signaal
		 reset		: in std_logic;							--! rst
		 sdi		: in std_logic;
		 sel		: in std_logic_vector(1 downto 0);
		 pn_start	: out std_logic;
		 sdo_spread : out std_logic);		 
end access_layer;

architecture behave of access_layer is
	component pn_generator is
		port(clk		: in std_logic;
			 reset		: in std_logic;
			 pn_start	: out std_logic;
			 pn_ml1 	: out std_logic;
			 pn_ml2 	: out std_logic;
			 pn_gold	: out std_logic);	
	end component;
	signal ipn_start : std_logic;
	signal ipn_ml1, ipn_ml2, ipn_gold : std_logic;

begin
	pn_generator_inst : pn_generator
		port map(clk 	  => clk,
				 reset 	  => reset,
				 pn_start => ipn_start,
				 pn_ml1   => ipn_ml1,
				 pn_ml2	  => ipn_ml2,
				 pn_gold  => ipn_gold);

	comb_access_layer : process(ipn_ml1, ipn_ml2, ipn_gold, sdi, sel)
	begin
		case sel is
			when "00" => 
				sdo_spread <= sdi;		
			when "01" =>
				sdo_spread <= sdi xor ipn_ml1;
			when "10" =>
				sdo_spread <= sdi xor ipn_ml1;
			when "11" =>
				sdo_spread <= sdi xor ipn_gold;	
			when others =>
				sdo_spread <= sdi;
		end case;
	end process comb_access_layer;
end behave;
		