library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity pn_generator is
	port(clk		: in std_logic;
		 reset		: in std_logic;
		 pn_start	: out std_logic;
		 pn_ml1 	: out std_logic;
		 pn_ml2 	: out std_logic;
		 pn_gold	: out std_logic);	
end pn_generator;

architecture behave of pn_generator is
	constant SEED1 : std_logic_vector(4 downto 0) := "00010";
	constant SEED2 : std_logic_vector(4 downto 0) := "00111";
	signal reg1_cur, reg1_next : std_logic_vector(4 downto 0);
	signal reg2_cur, reg2_next : std_logic_vector(4 downto 0);
begin
	sym_pn_generator : process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				reg1_cur <= SEED1;
				reg2_cur <= SEED2;
			else
				reg1_cur <= reg1_next;
				reg2_cur <= reg2_next;
			end if;
		end if;
	end process sym_pn_generator;

	com_pn_generator : process(reg1_cur, reg2_cur)
	begin
		reg1_next <= (reg1_cur(0) xor reg1_cur(3)) & reg1_cur(4 downto 1);
		reg2_next <= (reg2_cur(0) xor reg2_cur(1)
								  xor reg2_cur(3)
								  xor reg2_cur(4)) & reg2_cur(4 downto 1);
		-- ***************
		-- *** OUTPUTS ***
		-- ***************
		if reg1_cur = SEED1 then
			pn_start <= '1';
		else
			pn_start <= '0';
		end if;
		pn_ml1 	<= reg1_cur(0);
		pn_ml2 	<= reg2_cur(0);
		pn_gold <= reg1_cur(0) xor reg2_cur(0);	
	end process com_pn_generator;
end behave;