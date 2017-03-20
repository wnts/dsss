--------------------------------------------------
--! @file
--! @brief Application layer top module
--------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity application_layer is
	port(clk		: in std_logic;							--! Clock signaal
		 reset		: in std_logic;							--! rst
		 up			: in std_logic;							--! Signaal voor knop omhoog
		 down		: in std_logic;							--! Signalen voor knop omlaag
		 count		: out std_logic_vector(3 downto 0);		--! 4 bit data uitgang
		 segment	: out std_logic_vector(7 downto 0));	--! Zevensegment uitgang
end application_layer;

architecture behave of application_layer is

signal up_debounced, down_debounced : std_logic;			
signal up_edge, down_edge : std_logic;
signal count_intern : std_logic_vector(3 downto 0);

component debouncer is
   port(clk		: in std_logic;
		cha		: in std_logic;
		reset	: in std_logic;
		syncha	: out std_logic);
end component;

component counter is
	port(clk, reset : in std_logic;
		 up, down	: in std_logic;
		 count		: out std_logic_vector(3 downto 0));
end component;

component edge_detector is
	port(clk		: in std_logic;				 
		 syncha		: in std_logic;
         edge		: out std_logic);
end component;

component sevensegment is
	port(num_in		: in std_logic_vector(3 downto 0);
		 dot		: in std_logic;
		 seg_out	: out std_logic_vector(7 downto 0));
end component;

begin
	debouncer_up_inst : debouncer
		port map(clk => clk,
				 cha => up,
				 reset => reset,
				 syncha => up_debounced);
	debouncer_down_inst : debouncer
		port map(clk => clk,
				 cha => down,
				 reset => reset,
				 syncha => down_debounced);	
	edge_detector_up_inst : edge_detector
		port map(clk	=> clk,
				 syncha => up_debounced,				 
				 edge	=> up_edge);
	edge_detector_down_inst : edge_detector
		port map(clk	=> clk,
				 syncha => down_debounced,			
				 edge	=> down_edge);
	counter_inst : counter
		port map(clk	=> clk,
				 reset	=> reset,
				 up		=> up_edge,				 
				 down	=> down_edge,
				 count	=> count_intern);
	sevensegment_inst : sevensegment
		port map(num_in		=> count_intern,
				 dot		=> '0',
				 seg_out	=> segment);
count <= count_intern;
end behave;
		
