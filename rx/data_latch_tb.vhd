library ieee;
library dsss_rx;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_latch_tb is
end data_latch_tb;

architecture structural of data_latch_tb is
	
	component data_latch is
		port(clk		: in std_logic;
			 ce			: in std_logic;
			 preamble	: in std_logic_vector(6 downto 0);
			 data_in	: in std_logic_vector(3 downto 0);
			 data_out	: out std_logic_vector(3 downto 0));
	end component;


	for uut : data_latch use entity work.data_latch(behave);

	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk, ce			 : std_logic;
	signal data_in, data_out : std_logic_vector(3 downto 0);
	signal preamble			 : std_logic_vector(6 downto 0);
	signal data				 : std_logic_vector(10 downto 0);

	constant testdata : std_logic_vector(10 downto 0) := "01111101011";
begin
	uut : data_latch
		port map(clk 		 => clk,
				 ce			 => ce,
				 data_in	 => data_in,
				 data_out	 => data_out,
				 preamble	 => preamble);
	clock : process
	begin 
		clk <= '0';
		wait for period/2;
		loop
			clk <= '0';
			wait for period / 2;
			clk <= '1';
			wait for period / 2;
			exit when end_of_sim;
		end loop;
		wait;
	end process clock;

	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0)) is
		begin
			reset		<= stimvect(2);
		    ce		    <= stimvect(1);
			b			<= stimvect(0);
			wait for period;
		end tbvector;
	begin
		tbvector("100");
		tbvector("100");
		-- testdata inschuiven
		for i in 0 to 10 loop
			tbvector("01" & testdata(i));
		end loop;
		tbvector("010");
		-- testdata proberen in te schuiven met ce = 0
		for i in 0 to 10 loop
			tbvector("00" & testdata(i));
		end loop;
		end_of_sim <= true;
		wait;
	end process tb;
end;