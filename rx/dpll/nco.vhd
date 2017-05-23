library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nco is
	port(clk			: in std_logic;
		 reset			: in std_logic;	     		 
		 sem			: in std_logic_vector(4 downto 0);
		 chip_sample	: out std_logic;
		 chip_sample1	: out std_logic;
		 chip_sample2	: out std_logic);
end nco;

architecture behave of nco is	
	-- constanten voor de segmenten mee aan te duiden
	constant seg_a : std_logic_vector(4 downto 0) := "10000";
	constant seg_b : std_logic_vector(4 downto 0) := "01000";
	constant seg_c : std_logic_vector(4 downto 0) := "00100";
	constant seg_d : std_logic_vector(4 downto 0) := "00010";
	constant seg_e : std_logic_vector(4 downto 0) := "00001";
	-- externe component declaratie
	component universal_counter is
		generic(N		: positive);
		port(clk		: in std_logic;
			 reset		: in std_logic;	     		 
			 en			: in std_logic;
		     up			: in std_logic						:= '0';
	         down		: in std_logic;						
			 load		: in std_logic;		
			 data		: in std_logic_vector(N-1 downto 0) := (others => '0');
			 count		: out std_logic_vector(N-1 downto 0);
			 max_tick	: out std_logic;
			 min_tick	: out std_logic);
	end component;
	-- interne signalen declaraties
	signal count : unsigned(4 downto 0);	
	signal load : std_logic;
	signal data : std_logic_vector(4 downto 0);
	signal present_chip_samples, next_chip_samples : std_logic_vector(1 downto 0) := "00";
	
begin
	-- counter instantieren
	counter_inst : universal_counter
		generic map(N => 5)
		port map(clk	 	 	 => clk,      
				 reset		 	 => reset,
				 en				 => '1',
				 up			 	 => open,
				 down		 	 => '1',
				 load		 	 => load,
				 data		 	 => data,
				 unsigned(count) => count,
				 min_tick	 	 => open,
				 max_tick	 	 => open);
	
	syn_nco : process(clk)
	begin
		if rising_edge(clk) then
			present_chip_samples <= next_chip_samples;
		end if;
	end process syn_nco;
   -- TODO: chip_sample delay met schuifregister
   -- DONE
	com_nco : process(count, sem, present_chip_samples)
	begin
		-- semaphore-naar-preload-waarde decoder
		case sem is
			when seg_a => 
				data <= "10010";	-- counter+3 = 18
			when seg_b => 
				data <= "10000";	-- counter+1 = 16
			when seg_c => 
				data <= "01111";	-- counter = 15
			when seg_d => 
				data <= "01110";	-- counter-1 = 14
			when seg_e => 
				data <= "01100";	-- counter-3 = 12
			when others =>
				data <= "01111";	-- counter = 15
		end case;
		-- als teller afloopt, herlaad 
		if count = 0 then
			load <= '1';		
		else
			load <= '0';
		end if;
		-- als teller afloopt, schuif chip_sample door om cs1, cs2 te verkrijgen
		if count = 0 then
			next_chip_samples <= present_chip_samples(0) & '1';
			chip_sample <= '1';
		else
			next_chip_samples <= present_chip_samples(0) & '0';
			chip_sample <= '0';
		end if;
		
		-- outputs
		chip_sample1 <= present_chip_samples(0);
		chip_sample2 <= present_chip_samples(1);
	end process com_nco;
end behave;