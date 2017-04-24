library ieee;
use ieee.std_logic_1164.all;

entity matched_filter is
	port(clk		: in std_logic;	     		 
	     reset		: in std_logic;		 
		 sdi		: in std_logic;
		 sel		: in std_logic_vector(1 downto 0);
		 seq_det	: out std_logic);
end matched_filter;

architecture behave of matched_filter is	
		signal reg_cur, reg_next : std_logic_vector(N-1 downto 0) := (others => '0');
begin
	syn_matched_filter : process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				reg_cur <= (others => '0');
			else
				reg_cur <= reg_next;
			end if;
		end if;
	end process syn_matched_filter;
	
	com_matched_filter : process(reg_next, reg_cur, sdi)
	begin
		reg_next <= reg_cur(N-2 downto 0) & sdi;
		sdo <= reg_cur(N-1);
	end process com_matched_filter;
end behave;