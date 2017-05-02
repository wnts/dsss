library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dpll_tb is
end dpll_tb;

architecture structural of dpll_tb is 
	-- component declaraties
	component dpll is
		port(clk			: in std_logic;
			 reset			: in std_logic;	     		 
		     sdi_spread		: in std_logic;
			 chip_sample	: out std_logic;
			 chip_sample1	: out std_logic;
			 chip_sample2	: out std_logic);
	end component;


for uut : dpll use entity work.dpll(behave);
 
	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk			: std_logic;
	signal reset		: std_logic;	     		 
	signal sdi_spread   : std_logic;
	signal chip_sample2 : std_logic;
	signal chip_sample1 : std_logic;
	signal chip_sample  : std_logic;

	signal pn0 : std_logic_vector(0 to 30) := "0000101011101100011111001101001";
	
begin
	uut: dpll
		port map(clk	 	  => clk,      
				 reset		  => reset,
				 sdi_spread	  => sdi_spread,
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

	chip_clk : process
		variable i : integer := 0;
	begin
		sdi_spread <= '0';
		wait for (period * 14);		
		loop
			i := (i + 1) mod 30;
			sdi_spread <= pn0(i);
			wait for (period * 16);
			exit when end_of_sim;
		end loop;
		wait;
	end process chip_clk;
		
		
	-- ************************************************************************
	--  Transition segment decoder
	-- *************************************************************************
	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(0 downto 0)) is
		begin	  
			reset <= stimvect(0);
		   wait for period;
		end tbvector;
	begin		
		-- Reset
		tbvector("1");		
		tbvector("1");		
		for i in 0 to 512 loop
			tbvector("0");
		end loop;
		end_of_sim <= true;
		wait;
	end process;
end;

	
	