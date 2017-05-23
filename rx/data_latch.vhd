library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- data_latch ---
-- Geeft data_in aan de output (data_out) wanneer 
-- preamble gelijk is aan de preamble waarde "011110"
--
-- Werkt synchroon en met ce signaal
entity data_latch is
	port(clk		: in std_logic;
		 ce			: in std_logic;
		 preamble	: in std_logic_vector(6 downto 0);
		 data_in	: in std_logic_vector(3 downto 0);
		 data_out	: out std_logic_vector(3 downto 0));
end data_latch;

architecture behave of data_latch is	
	signal data_present, data_next : std_logic_vector(3 downto 0) := (others => '0');
begin
	syn_data_latch : process(clk)
	begin
		if rising_edge(clk) and ce = '1' then
			data_present <= data_next;
		end if;
	end process syn_data_latch;
	
	com_data_latch : process(preamble, data_present)
	begin
		if preamble = "0111110" then
			data_next <= data_in;
		else
			data_next <= data_present;
		end if;
		data_out <= data_present;
	end process com_data_latch;
end behave;