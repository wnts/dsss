library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transition_seg_decoder is
	port(clk		: in std_logic;
		 reset		: in std_logic;	     		 
	     extb		: in std_logic;
		 seg		: out std_logic_vector(4 downto 0));
end transition_seg_decoder;

architecture behave of transition_seg_decoder is	
	-- constanten
	constant seg_a : std_logic_vector(4 downto 0) := "10000";
	constant seg_b : std_logic_vector(4 downto 0) := "01000";
	constant seg_c : std_logic_vector(4 downto 0) := "00100";
	constant seg_d : std_logic_vector(4 downto 0) := "00010";
	constant seg_e : std_logic_vector(4 downto 0) := "00001";
	-- interne signaal declaraties
	signal count : std_logic_vector(3 downto 0);
	-- externe component declaratie
	component universal_counter is
		generic(N		: positive);
		port(clk		: in std_logic;
			 reset		: in std_logic;	     		 
		     up			: in std_logic;
	         down		: in std_logic						:= '0';
			 load		: in std_logic						:= '0';		
			 data		: in std_logic_vector(N-1 downto 0) := (others => '0');
			 count		: out std_logic_vector(N-1 downto 0);
			 max_tick	: out std_logic;
			 min_tick	: out std_logic);
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
	
	com_transition_seg_decoder : process(count, extb)
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
	end process com_transition_seg_decoder;
end behave;