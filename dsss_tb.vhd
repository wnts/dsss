library ieee;
library dsss_rx;
library dsss_tx;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


-- Tweede test van de volledige rx/tx door 
-- het verbinden van de tx topmodule met de rx topmodule
entity dsss_tb is
end dsss_tb;

architecture structural of dsss_tb is

	component dsss_rx is
		port(clk			: in std_logic;	     		 
			 reset			: in std_logic;
			 rx_baseband	: in std_logic;
			 sel			: in std_logic_vector(1 downto 0));	
	end component;

	component dsss_tx is
		port(clk		: in std_logic;							--! Clock signaal
			 reset		: in std_logic;							--! rst
			 up			: in std_logic;							--! UP knop
			 down 		: in std_logic;							--! DOWN knop
			 sel		: in std_logic_vector(1 downto 0);		--! Psuedo-noise code selectie
			 segment	: out std_logic_vector(7 downto 0);		--! 7 segment output
			 sdo_spread	: out std_logic);		 				--! De als pn-codes geencodeerde data
	end component;
	

	for tx_inst : dsss_tx use entity dsss_tx.dsss_tx(behave);
	for rx_inst : dsss_rx use entity dsss_rx.dsss_rx(behave);


	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk_rx, clk_tx, reset	: std_logic;
	signal bit_sample	: std_logic;
	signal databit		: std_logic;
	signal sel			: std_logic_vector(1 downto 0);

	signal up, down		: std_logic;
	signal segment 		: std_logic_vector(7 downto 0);
	signal sdo_spread	: std_logic;
	

begin
	rx_inst : dsss_rx
		port map(clk 		 => clk_rx,
				 reset		 => reset,
				 rx_baseband => sdo_spread,		-- uitgang zender verbinden met ingang ontvanger
				 sel		 => sel);


	tx_inst : dsss_tx
		port map(clk        => clk_tx,
				 reset      => reset,
				 up	        => up,
				 down       => down,
				 sel        => sel,
				 segment    => segment,
				 sdo_spread => sdo_spread);

	clock_rx : process
	begin 
		clk_rx <= '0';
		wait for period/2;
		loop
			clk_rx <= '0';
			wait for period / 2;
			clk_rx <= '1';
			wait for period / 2;
			exit when end_of_sim;
		end loop;
		wait;
	end process clock_rx;


	clock_tx : process
	begin 
		clk_tx <= '0';
		wait for 16*period/2;
		loop
			clk_tx <= '0';
			wait for 16*period / 2;
			clk_tx <= '1';
			wait for 16*period / 2;
			exit when end_of_sim;
		end loop;
		wait;
	end process clock_tx;
		

	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(4 downto 0)) is
		begin
			reset		<= stimvect(4);
			up			<= stimvect(3);
			down		<= stimvect(2);
			sel			<= stimvect(1 downto 0);
			wait for period * 16;
		end tbvector;
	begin
		tbvector("10011");
		tbvector("10011");
		tbvector("00011"); -- reset
		wait for 16*period*1000;
		tbvector("01011"); -- UP knop indukken
		tbvector("01011");
		tbvector("01011");
		tbvector("01011");
		tbvector("01011");
		tbvector("01011");
		tbvector("01011");
		tbvector("01011");
		tbvector("00011");
		wait for 16*period*1000;
		tbvector("01011"); -- UP knop indrukken
		tbvector("01011");
		tbvector("01011");
		tbvector("01011");
		tbvector("01011");
		wait for 16*period*1000;
		tbvector("00111"); -- DOWN knop indrukken
		tbvector("00111");
		tbvector("00111");
		tbvector("00111");
		tbvector("00111");		
		wait for 16*period*1000;
		end_of_sim <= true;
		wait;
	end process tb;
end;