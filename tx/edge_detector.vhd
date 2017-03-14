library ieee;
use ieee.std_logic_1164.all;

entity edge_detector is
	port(clk		: in std_logic;	     		 
	     syncha		: in std_logic;
         edge		: out std_logic);
end edge_detector;

architecture behave of edge_detector is	
	signal sig_cur	    :	std_logic;
	signal sig_prev		: 	std_logic;
	
begin
	syn_edge_detector : process(clk)
	begin
		if rising_edge(clk) then
			sig_prev <= sig_cur;			
		end if;
	end process syn_edge_detector;
	
	com_edge_detector : process(sig_prev, sig_cur, syncha)
	begin
		sig_cur <= syncha;
		edge <= (sig_cur xor sig_prev) and sig_cur;
	end process com_edge_detector;
end behave;
		
	
	