library ieee;
use ieee.std_logic_1164.all;

entity access_layer is
	port(clk			: in std_logic;	     		 
		 reset			: in std_logic;
		 rx_baseband	: in std_logic;
		 sel			: in std_logic_vector(1 downto 0);
		 bit_sample		: out std_logic;
		 databit		: out std_logic);
end access_layer;

architecture behave of access_layer is		
	-- component declaraties
	component dpll is
		port(clk			: in std_logic;
			 reset			: in std_logic;	     		 
		     sdi_spread		: in std_logic;
			 chip_sample	: out std_logic;
			 chip_sample1	: out std_logic;
			 chip_sample2	: out std_logic);
	end component;
	component matched_filter is
	port(clk		: in std_logic;	     		 
		 reset		: in std_logic;
		 ce			: in std_logic;
		 sdi_spread	: in std_logic;
		 sel		: in std_logic_vector(1 downto 0);
		 seq_det	: out std_logic);
	end component;
	component pn_generator is
		port(clk		: in std_logic;
			 reset		: in std_logic;
			 en			: in std_logic;
			 full_seq	: out std_logic;
			 pn_ml1 	: out std_logic;
			 pn_ml2 	: out std_logic;
			 pn_gold	: out std_logic);	
	end component;
	component correlator is
		port(clk			: in std_logic;	     		 
			 reset			: in std_logic;
			 chip_sample2	: in std_logic;
			 sdi_despread	: in std_logic;
			 bit_sample		: in std_logic;
			 databit		: out std_logic);
	end component;
	-- interne signaal declaraties
	signal chip_sample, chip_sample1, chip_sample2 : std_logic;
	signal pn_ml1, pn_ml2, pn_gold : std_logic;
	signal pn_reset : std_logic;
	signal sdi_despread, sdi_despread_cur, sdi_despread_next : std_logic := '0';
	signal full_seq : std_logic;
	signal pn_seq : std_logic;
begin
	-- componenten instantieren
	dpll_inst : dpll
		port map(clk		  => clk,
				 reset		  => reset,
				 sdi_spread	  => rx_baseband,
				 chip_sample  => chip_sample,
				 chip_sample1 => chip_sample1,
				 chip_sample2 => chip_sample2);
	matched_filter_inst : matched_filter
		port map(clk		=> clk,
				 reset		=> reset,
				 ce			=> chip_sample,
				 sdi_spread => rx_baseband,
				 sel		=> sel,
				 seq_det	=> pn_reset);
	pn_generator_inst : pn_generator
		port map(clk	  => clk,
				 reset	  => pn_reset,
				 en		  => chip_sample1,
				 full_seq => full_seq,
				 pn_ml1   => pn_ml1,
				 pn_ml2   => pn_ml2,
				 pn_gold  => pn_gold);
	correlator_inst : correlator
		port map(clk		  => clk,
				 reset		  => reset,
				 chip_sample2 => chip_sample2,
				 sdi_despread => sdi_despread,
				 bit_sample	  => full_seq,
				 databit	  => databit);
		
	syn_access_layer: process(clk)
	begin
		if rising_edge(clk) and chip_sample2 = '1' then
			sdi_despread_cur <= sdi_despread_next;
		end if;
	end process syn_access_layer;
	com_access_layer : process(sel, pn_ml1, pn_ml2, pn_gold, pn_seq, rx_baseband, full_seq)
	begin
		-- multiplexer voor pn code selectie
		case sel is
			when "00" =>
				pn_seq <= '0';
			when "01" =>
				pn_seq <= pn_ml1;
			when "10" =>
				pn_seq <= pn_ml2;
			when "11" =>
				pn_seq <= pn_gold;
			when others =>
				pn_seq <= '0';
		end case;
		sdi_despread_next <= rx_baseband xor pn_seq;
		sdi_despread <= sdi_despread_cur;
		bit_sample <= full_seq;
	end process com_access_layer;
end behave;