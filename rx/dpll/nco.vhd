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
	-- constanten
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
		     up			: in std_logic						:= '0';
	         down		: in std_logic;						
			 load		: in std_logic;		
			 data		: in std_logic_vector(N-1 downto 0) := (others => '0');
			 count		: out std_logic_vector(N-1 downto 0);
			 max_tick	: out std_logic;
			 min_tick	: out std_logic);
	end component;
	-- interne signalen declaraties
	signal count : unsigned(3 downto 0);	
	signal load : std_logic;
	signal data : std_logic_vector(3 downto 0);
begin
	-- counter instantieren
	counter_inst : universal_counter
		generic map(N => 4)
		port map(clk	 	 	 => clk,      
				 reset		 	 => reset,
				 up			 	 => open,
				 down		 	 => '1',
				 load		 	 => load,
				 data		 	 => data,
				 unsigned(count) => count,
				 min_tick	 	 => open,
				 max_tick	 	 => open);
	
	com_nco : process(count, sem)
	begin
		-- semaphore-naar-preload-waarde decoder
		case sem is
			when seg_a => 
				data <= "1010";	-- counter+3 = 10
			when seg_b => 
				data <= "1000";	-- counter+1 = 8
			when seg_c => 
				data <= "0111";	-- counter = 7
			when seg_d => 
				data <= "0110";	-- counter-1 = 6
			when seg_e => 
				data <= "0100";	-- counter-3 = 4
			when others =>
				data <= "0111";	-- counter = 7
		end case;
		if count = 0 then
			load <= '1';		
		else
			load <= '0';
		end if;
		-- outputs
		if count = 2 then
			chip_sample2 <= '1';
		else
			chip_sample2 <= '0';
		end if;

		if count = 1 then
			chip_sample1 <= '1';
		else
			chip_sample1 <= '0';
		end if;

		if count = 0 then
			chip_sample <= '1';
		else
			chip_sample <= '0';
		end if;		
	end process com_nco;
end behave;