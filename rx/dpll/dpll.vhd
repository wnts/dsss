library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dpll is
	port(clk			: in std_logic;
		 reset			: in std_logic;	     		 
	     sdi_spread		: in std_logic;
		 chip_sample	: out std_logic;
		 chip_sample1	: out std_logic;
		 chip_sample2	: out std_logic);
end dpll;

architecture behave of dpll is	
	-- interne signaal declaraties
	signal count : std_logic_vector(3 downto 0);
	-- externe component declaratie
	component transition_detector is
		port(clk		: in std_logic;	     		 
		     sdi_spread	: in std_logic;
	         exTB		: out std_logic);
	end component;
	component transition_seg_decoder is
		port(clk		: in std_logic;
			 reset		: in std_logic;	     		 
		     extb		: in std_logic;
			 seg		: out std_logic_vector(4 downto 0));
	end component;


begin
	-- counter instantieren	
	counter_inst : universal_counter
		generic map(N => 4)
		port map(clk	 	 => clk,      
				 reset		 => extb,
				 up			 => '1',
				 down		 => open,
				 load		 => open,
				 data		 => open,
				 count		 => count,
				 min_tick	 => open,
				 max_tick	 => open);
	
	com_dpll : process(count, extb)
	begin
		if unsigned(count)  >= 0 and unsigned(count) <= 4 then
			seg <= seg_a;
		elsif unsigned(count) >= 5 and unsigned(count) <= 6 then
			seg <= seg_b;
		elsif unsigned(count) >= 7 and unsigned(count) <= 8 then
			seg <= seg_c;
		elsif unsigned(count) >= 9 and unsigned(count) <= 10 then
			seg <= seg_d;
		elsif unsigned(count) >= 11 and unsigned(count) <= 15 then
			seg <= seg_e; 
		else
			seg <= seg_c;
		end if;
	end process com_dpll;
end behave;