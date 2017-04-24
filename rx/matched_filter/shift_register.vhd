library ieee;
use ieee.std_logic_1164.all;

entity shift_register is
	generic (N 		: natural := 31);
	port(clk		: in std_logic;	     		 
	     reset		: in std_logic;		 
		 sdi		: in std_logic;
		 sdo		: out std_logic);
end shift_register;

architecture behave of shift_register is	
		signal reg_cur, reg_next : std_logic_vector(N-1 downto 0) := (others => '0');
begin
	syn_shift_register : process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				reg_cur <= (others => '0');
			else
				reg_cur <= reg_next;
			end if;
		end if;
	end process syn_shift_register;
	
	com_shift_register : process(reg_next, reg_cur, sdi)
	begin
		reg_next <= reg_cur(N-2 downto 0) & sdi;
		sdo <= reg_cur(N-1);
	end process com_shift_register;
end behave;