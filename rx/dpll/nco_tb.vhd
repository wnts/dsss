library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity nco_tb is
end nco_tb;

architecture structural of nco_tb is 
	-- component declaraties
	component nco is
		port(clk			: in std_logic;
			 reset			: in std_logic;	     		 
			 sem			: in std_logic_vector(4 downto 0);
			 chip_sample	: out std_logic;
			 chip_sample1	: out std_logic;
			 chip_sample2	: out std_logic);
	end component;


for uut : nco use entity work.nco(behave);
 
	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk			: std_logic;
	signal reset		: std_logic;	     		 
	signal sem			: std_logic_vector(4 downto 0);
	signal chip_sample2 : std_logic;
	signal chip_sample1 : std_logic;
	signal chip_sample  : std_logic;
begin
	uut: nco
		port map(clk	 	  => clk,      
				 reset		  => reset,
				 sem		  => sem,
				 chip_sample2 => chip_sample2,
				 chip_sample1 => chip_sample1,
				 chip_sample  => chip_sample);
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
		procedure tbvector(constant stimvect : in std_logic_vector(0 downto 0))is
		begin	  
			reset <= stimvect(0);
		   wait for period;
		end tbvector;
	begin		
		-- Reset
		tbvector("1");		
		tbvector("1");		
		-- doorloop alle segmenten een keer
		sem <= "10000";
		for i in 0 to 48 loop
			tbvector("0");
		end loop;
		sem <= "01000";
		for i in 0 to 48 loop
			tbvector("0");
		end loop;
		sem <= "00100";
		for i in 0 to 48 loop
			tbvector("0");
		end loop;
		sem <= "00010";
		for i in 0 to 48 loop
			tbvector("0");
		end loop;
		sem <= "00001";
		for i in 0 to 48 loop
			tbvector("0");
		end loop;
		end_of_sim <= true;
		wait;
	end process;
end;

	
	