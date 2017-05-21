library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity matched_filter_tb is
end matched_filter_tb;

architecture structural of matched_filter_tb is 
	-- component declaraties
	component matched_filter is
		port(clk		: in std_logic;	     		 
			 reset		: in std_logic;
			 ce			: in std_logic;
			 sdi_spread	: in std_logic;
			 sel		: in std_logic_vector(1 downto 0);
			 seq_det	: out std_logic);
	end component;


for uut : matched_filter use entity work.matched_filter(behave);
 
	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	constant no_ptrn   : std_logic_vector(30 downto 0) := (others => '0');
	constant ml1_ptrn  : std_logic_vector(30 downto 0) := "0010110011111000110111010100001";
	constant ml2_ptrn  : std_logic_vector(30 downto 0) := "1001101111101000100101011000011";
	constant gold_ptrn : std_logic_vector(30 downto 0) := ml1_ptrn xor ml2_ptrn;

	signal clk			: std_logic;
	signal reset		: std_logic;
	signal ce			: std_logic;
	signal sdi_spread	: std_logic;
	signal seq_det   	: std_logic;
	signal sel			: std_logic_vector(1 downto 0);
begin
	uut: matched_filter
		port map(clk	 	 => clk,      
				 reset		 => reset,
				 ce		 	 => ce,
				 sel		 => sel,
				 sdi_spread	 => sdi_spread,
				 seq_det	 => seq_det);
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
	--  Matched filter testbench
	-- *************************************************************************
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(4 downto 0))is
		begin	  
			reset <= stimvect(4);
			ce <= stimvect(3);
			sdi_spread <= stimvect(2);
			sel <= stimvect(1 downto 0);
		   wait for period;
		end tbvector;
	begin		
		-- reset
		tbvector("10111");
		tbvector("10111");
		-- eerst wat rommel aanleggen...		
		for i in 0 to 32 loop
			tbvector("01111");
		end loop;
		-- even tussenpauze om te controleren of seq_det laag blijft 
		tbvector("01111");		
		tbvector("01111");		

		-- ***************
		-- no_ptrn test 
		-- ***************
		-- ce even afzetten zodat we in waveform overgang kunnen zien
		tbvector("00100");
		tbvector("00100");
		-- no_ptrn code aanleggen en selecteren via sel -> dit moet een seq_det puls geven na de for loop
		for i in 0 to 30 loop
			tbvector("01" & no_ptrn(i) & "00");
		end loop;
		-- even tussenpauze om te controleren of seq_det terug laag wordt 
		tbvector("01100");		
		tbvector("01100");		

		-- ***************
		-- ml1_ptrn test 
		-- ***************
		-- ce even afzetten zodat we in waveform overgang kunnen zien
		tbvector("00011");
		tbvector("00011");
		-- ml1_ptrn code aanleggen en selecteren via sel -> dit moet een seq_det puls geven na de for loop
		for i in 0 to 30 loop
			tbvector("01" & ml1_ptrn(i) & "01");
		end loop;
		-- even tussenpauze om te controleren of seq_det terug laag wordt 
		tbvector("01001");		
		tbvector("01001");		

		-- ***************
		-- ml2_ptrn test 
		-- ***************
		-- ce even afzetten zodat we in waveform overgang kunnen zien
		tbvector("00010");
		tbvector("00010");
		-- ml1_ptrn code aanleggen en selecteren via sel -> dit moet een seq_det puls geven na de for loop
		for i in 0 to 30 loop
			tbvector("01" & ml2_ptrn(i) & "10");
		end loop;
		-- even tussenpauze om te controleren of seq_det terug laag wordt 
		tbvector("01110");		
		tbvector("01110");		


		-- ***************
		-- gold_ptrn test 
		-- ***************
		-- ce even afzetten zodat we in waveform overgang kunnen zien
		tbvector("00011");
		tbvector("00011");		
		-- gold_ptrn code aanleggen en selecteren via sel -> dit moet een seq_det puls geven na de for loop
		for i in 0 to 30 loop
			tbvector("01" & gold_ptrn(i) & "11");
		end loop;
		-- even tussenpauze om te controleren of seq_det terug laag wordt 
		tbvector("01111");		
		tbvector("01111");		


		-- ce even afzetten zodat we in waveform overgang kunnen zien
		tbvector("00011");
		tbvector("00011");
		-- ml1_ptrn code aanleggen terwijl we pn_ml2 selecteren via sel -> dit mag geen seq_det puls geven na de for loop
		for i in 0 to 30 loop
			tbvector("01" & ml1_ptrn(i) & "10");
		end loop;
		-- even tussenpauze om te controleren dat seq_det laag is en blijft
		tbvector("01111");

		end_of_sim <= true;
		wait;
	end process;
end;

	
	