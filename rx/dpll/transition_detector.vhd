library ieee;
use ieee.std_logic_1164.all;

entity transition_detector is
	port(clk		: in std_logic;	     		 
	     sdi_spread	: in std_logic;
         exTB		: out std_logic);
end transition_detector;

architecture behave of transition_detector is	
	signal present_sig : std_logic;
	signal prev_sig : std_logic;

begin
	syn_transition_detector : process(clk)
	begin
		if rising_edge(clk) then
			prev_sig <= present_sig;
		end if;
	end process syn_transition_detector;

	com_transition_detector : process(present_sig, prev_sig, sdi_spread)
	begin
		present_sig <= sdi_spread;
		exTB <= present_sig xor prev_sig;
	end process com_transition_detector;	

end behave;