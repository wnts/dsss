library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity access_layer_tb is
end access_layer_tb;

architecture structural of access_layer_tb is

	component access_layer is
		port(clk			: in std_logic;	     		 
			 reset			: in std_logic;
			 rx_baseband	: in std_logic;
			 sel			: in std_logic_vector(1 downto 0);
			 bit_sample		: out std_logic;
			 databit		: out std_logic);
	end component;

	for uut : access_layer use entity work.access_layer(behave);

	constant no_ptrn   : std_logic_vector(30 downto 0) := (others => '0');
	constant ml1_ptrn  : std_logic_vector(30 downto 0) := "0010110011111000110111010100001";
	constant ml2_ptrn  : std_logic_vector(30 downto 0) := "1001101111101000100101011000011";
	constant gold_ptrn : std_logic_vector(30 downto 0) := ml1_ptrn xor ml2_ptrn;

	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk, reset	: std_logic;
	signal rx_baseband	: std_logic;
	signal bit_sample	: std_logic;
	signal databit		: std_logic;
	signal sel			: std_logic_vector(1 downto 0);

begin
	uut : access_layer
		port map(clk 		 => clk,
				 reset		 => reset,
				 rx_baseband => rx_baseband,
				 sel		 => sel,
				 bit_sample  => bit_sample,
			     databit	 => databit);


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
		procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0)) is
		begin
			reset		<= stimvect(1);
			rx_baseband <= stimvect(0);
			wait for period * 16;
		end tbvector;
	begin
		sel <= "11";
		tbvector("10");
		tbvector("10");
		for i in 0 to 30 loop
			tbvector("0"& gold_ptrn(i));
		end loop;
		for i in 0 to 30 loop
			tbvector("0"& not gold_ptrn(i));
		end loop;
		for i in 0 to 30 loop
			tbvector("0"& gold_ptrn(i));
		end loop;
		for i in 0 to 30 loop
			tbvector("0"& gold_ptrn(i));
		end loop;
		end_of_sim <= true;
		wait;
	end process tb;
end;