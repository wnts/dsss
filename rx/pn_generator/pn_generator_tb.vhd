library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pn_generator_tb is
end pn_generator_tb;

architecture structural of pn_generator_tb is

	component pn_generator is
		port(clk		: in std_logic;
			 reset		: in std_logic;
			 en			: in std_logic;
			 full_seq	: out std_logic;
			 pn_ml1 	: out std_logic;
			 pn_ml2 	: out std_logic;
			 pn_gold	: out std_logic);	
	end component;

	for uut : pn_generator use entity work.pn_generator(behave);

	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk, reset	: std_logic;
	signal en			: std_logic;
	signal full_seq		: std_logic;
	signal pn_ml1		: std_logic;
	signal pn_ml2		: std_logic;
	signal pn_gold		: std_logic; 
begin
	uut : pn_generator
		port map(clk 		=> clk,
				 reset		=> reset,
				 en		    => en,
				 full_seq	=> full_seq,
				 pn_ml1		=> pn_ml1,
				 pn_ml2		=> pn_ml2,
				 pn_gold	=> pn_gold);

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
			wait for period;
		end tbvector;
	begin
		en <= '1';
		reset <= '1';
		wait for period;
		wait for period;
		reset <= '0';
		wait for period * 64;
		en <= '0';
		wait for period * 16;
		en <= '1';
		wait for period * 32;
		end_of_sim <= true;
		wait;
	end process tb;
end;