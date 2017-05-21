library ieee;
use ieee.std_logic_1164.all;

entity correlator is
	port(clk			: in std_logic;	     		 
		 reset			: in std_logic;
		 chip_sample2	: in std_logic;
		 sdi_despread	: in std_logic;
		 bit_sample		: in std_logic;
		 databit		: out std_logic);
end correlator;

architecture behave of correlator is		
	component universal_counter is
		generic(N		: positive);
		port(clk		: in std_logic;
			 reset		: in std_logic;	 
			 en			: in std_logic;    		 
		     up			: in std_logic;
	         down		: in std_logic;
			 load		: in std_logic;		
			 data		: in std_logic_vector(N-1 downto 0);
			 count		: out std_logic_vector(N-1 downto 0);
			 max_tick	: out std_logic;
			 min_tick	: out std_logic);
	end component;
	signal present_databit, next_databit : std_logic;
	signal up, down : std_logic;
	signal count : std_logic_vector(5 downto 0);
	signal sdi_despread_b : std_logic;
begin
	sdi_despread_b <= not sdi_despread;
	universal_counter_inst : universal_counter
		generic map(N => 6)
		port map(clk		=> clk,
				 reset		=> reset,
				 en			=> chip_sample2,
				 up			=> sdi_despread,
				 down		=> sdi_despread_b,
				 load		=> bit_sample,
				 data		=> "100000",
				 count		=> count,
				 max_tick	=> open,
				 min_tick 	=> open);

	syn_correlator : process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				present_databit <= '0';
			else
				present_databit <= next_databit;			
			end if;
		end if;
	end process syn_correlator;

	com_correlator : process(sdi_despread, bit_sample, present_databit)
	begin
		if bit_sample = '1' then
			next_databit <= count(5);
		else
			next_databit <= present_databit;
		end if;
		-- output
		databit <= present_databit;
	end process com_correlator;

end behave;