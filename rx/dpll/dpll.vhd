library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dpll is
	port(clk			: in std_logic;
		 reset			: in std_logic;	     		 
	     sdi_spread		: in std_logic;
		 chip_sample	: out std_logic;
		 chip_sample1	: out std_logic;
		 chip_sample2	: out std_logic);
end dpll;

architecture behave of dpll is	
	-- interne signaal declaraties
	signal extb : std_logic;
	signal seg, sem : std_logic_vector(4 downto 0);
	signal cs, cs1, cs2 : std_logic;
	-- externe component declaratie
	component transition_detector is
		port(clk		: in std_logic;	     		 
		     sdi_spread	: in std_logic;
	         exTB		: out std_logic);
	end component;
	component transition_seg_decoder is
		port(clk		: in std_logic;
			 reset		: in std_logic;	     		 
		     extb		: in std_logic;
			 seg		: out std_logic_vector(4 downto 0));
	end component;
	component semaphore is
		port(clk		: in std_logic;
			 reset		: in std_logic;	     		 
		     arm		: in std_logic;
	         fire		: in std_logic;
			 seg		: in std_logic_vector(4 downto 0);
			 sem		: out std_logic_vector(4 downto 0));		
	end component;
	component nco is
		port(clk			: in std_logic;
			 reset			: in std_logic;	     		 
			 sem			: in std_logic_vector(4 downto 0);
			 chip_sample	: out std_logic;
			 chip_sample1	: out std_logic;
			 chip_sample2	: out std_logic);
	end component;
begin
	-- transition detector instantieren		
	transition_detector_inst : transition_detector
		port map(clk		=> clk,
				 sdi_spread => sdi_spread,
				 extb		=> extb);
	-- transition-naar-segment decoder instantieren
	transition_seg_decoder_inst : transition_seg_decoder
		port map(clk		=> clk,
				 reset		=> reset,
				 extb		=> extb,
				 seg		=> seg);
	-- semaphore instantieren
	semaphore_inst : semaphore
		port map(clk		=> clk,
				 reset		=> reset,
				 arm		=> extb,
				 fire		=> cs,
				 seg		=> seg,
				 sem		=> sem);
	-- nco instantieren
	nco_inst : nco
		port map(clk			=> clk,
				 reset		 	=> reset,
				 sem		 	=> sem,
				 chip_sample 	=> cs,
				 chip_sample1	=> cs1,
				 chip_sample2	=> cs2);
	-- outputs
	chip_sample  <= cs;
	chip_sample1 <= cs1;
	chip_sample2 <= cs2;	
end behave;