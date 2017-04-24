library ieee;
use ieee.std_logic_1164.all;

entity transition_detector is
	port(clk		: in std_logic;	     		 
	     sdi_spread	: in std_logic;
         exTB		: out std_logic);
end transition_detector;

architecture behave of transition_detector is	
	signal sdi_spread_prev : std_logic;
		signal edge_up, edge_down : std_logic;
begin
	syn_transition_detector : process(clk)
	begin
		if rising_edge(clk) then
			sdi_spread_prev <= sdi_spread;
		end if;
	end process syn_transition_detector;
	
	com_transition_detector : process(sdi_spread_prev, sdi_spread)
	begin
		edge_up <= (not sdi_spread_prev) and (sdi_spread);
		edge_down <= (sdi_spread_prev) and (sdi_spread);
		exTB <= edge_down or edge_up;
	end process com_transition_detector;
end behave;