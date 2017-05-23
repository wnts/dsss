library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_shiftregister is
	generic(N		: positive);
	port(clk		: in std_logic;
		 ce			: in std_logic;
		 reset		: in std_logic;	     		 
		 b			: in std_logic;	
		 data		: out std_logic_vector(N-1 downto 0));
end data_shiftregister;

architecture behave of data_shiftregister is	
	signal reg_present, reg_next : std_logic_vector(N-1 downto 0) := (others => '0');
begin
	syn_data_shiftregister : process(clk)
	begin
		if rising_edge(clk) and ce = '1' then
			if reset = '1' then	
				reg_present <= (others => '0');
			else
				reg_present <= reg_next;
			end if;
		end if;
	end process syn_data_shiftregister;
	
	com_data_shiftregister : process(b, reg_present)
	begin
		reg_next <= reg_present(N-1-1 downto 0) & b;  
		data <= reg_present;
	end process com_data_shiftregister;
end behave;