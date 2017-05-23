library ieee;
library dsss_rx;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_shiftregister_tb is
end data_shiftregister_tb;

architecture structural of data_shiftregister_tb is
	
	component data_shiftregister is
		generic(N		: positive);
		port(clk		: in std_logic;
			 ce			: in std_logic;
			 reset		: in std_logic;	     		 
			 b			: in std_logic;	
			 data		: out std_logic_vector(N-1 downto 0));
	end component;

	for uut : data_shiftregister use entity work.data_shiftregister(behave);

	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk, reset, b, ce	: std_logic;
	signal data					: std_logic_vector(10 downto 0);

	constant testdata : std_logic_vector(10 downto 0) := "01111010110";
begin
	uut : data_shiftregister
		generic map(N => 11)
		port map(clk 		 => clk,
				 ce			 => ce,
				 reset		 => reset,
				 b			 => b,
				 data		 => data);

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