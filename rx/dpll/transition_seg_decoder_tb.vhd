library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity transition_seg_decoder_tb is
end transition_seg_decoder_tb;

architecture structural of transition_seg_decoder_tb is 
	-- component declaraties
	component transition_seg_decoder is
		port(clk		: in std_logic;
			 reset		: in std_logic;	     		 
		     extb		: in std_logic;
			 seg		: out std_logic_vector(4 downto 0));
	end component;


for uut : transition_seg_decoder use entity work.transition_seg_decoder(behave);
 
	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk			: std_logic;
	signal reset		: std_logic;	     		 
	signal extb			: std_logic;
	signal seg			: std_logic_vector(4 downto 0);
begin
	uut: transition_seg_decoder
		port map(clk	 	 => clk,      
				 reset		 => reset,
				 extb		 => extb,
				 seg		 => seg);
	clock : process
	begin 
		clk <= '0';
		wait for period/2;
		loop
			clk <= '0';
			wait for period/2;
			clk <= '1';
			wait for period/2;
			exit when end_of_sim;
		end loop;
		wait;
	end process clock;
		
	-- ************************************************************************
	--  Transition segment decoder
	-- *************************************************************************
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
		begin	  
			reset <= stimvect(1);
			extb  <= stimvect(0);
		   wait for period;
		end tbvector;
	begin		
		-- Reset
		tbvector("10");		
		tbvector("10");
		-- extb puls
		tbvector("01");
		tbvector("00");
		-- doorloop alle segmenten een keer
		for i in 0 to 15 loop
			tbvector("00");
		end loop;
		end_of_sim <= true;
		wait;
	end process;
end;

	
	