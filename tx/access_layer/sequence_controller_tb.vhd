library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity sequence_controller_tb is
end sequence_controller_tb;

architecture structural of sequence_controller_tb is

	component sequence_controller is
		port(clk 		: in std_logic;
			 reset		: in std_logic;
			 pn_start 	: in std_logic;
			 ld			: out std_logic;
			 sh			: out std_logic);
	end component;

	for uut : sequence_controller use entity work.sequence_controller(behave);

	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk, reset, pn_start, ld, sh	: std_logic;
begin
	uut : sequence_controller
		port map(clk 		=> clk,
				 reset		=> reset,
				 ld 		=> ld,
				 sh			=> sh,
				 pn_start	=> pn_start);

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
			pn_start <= stimvect(1);
			reset 	 <= stimvect(0);
			wait for period;
		end tbvector;
	begin
		tbvector("01");
		tbvector("01");
		for i in 1 to 20 loop
			tbvector("10");
			tbvector("00");
			wait for period * 30;
		end loop;


		end_of_sim <= true;
		wait;
	end process tb;
end;
