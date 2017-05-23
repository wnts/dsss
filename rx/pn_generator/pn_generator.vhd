library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

-- pn_generator_rx --
-- Identiek aan pn_generator van de zender maar dan met
-- een extra uitgang full_seq; deze wordt 1 puls bij elke
-- volledige 31 chip iteratie van het schuifregister
entity pn_generator_rx is
	port(clk		: in std_logic;
		 reset		: in std_logic;
		 en			: in std_logic;
		 full_seq	: out std_logic;
		 pn_ml1 	: out std_logic;
		 pn_ml2 	: out std_logic;
		 pn_gold	: out std_logic);	
end pn_generator_rx;

architecture behave of pn_generator_rx is
	component edge_detector is
	port(clk		: in std_logic;	     		 
	     syncha		: in std_logic;
         edge		: out std_logic);
	end component;
	constant SEED1 : std_logic_vector(4 downto 0) := "00010";
	constant FULL1 : std_logic_vector(4 downto 0) := "00001";
	constant SEED2 : std_logic_vector(4 downto 0) := "00111";

	signal reg1_cur, reg1_next : std_logic_vector(4 downto 0) := SEED1;
	signal reg2_cur, reg2_next : std_logic_vector(4 downto 0) := SEED2;
	signal syncha : std_logic;
begin
	edge_detector_inst : edge_detector
		port map(clk 	=> clk,
				 syncha => syncha,
				 edge	=> full_seq);
	sym_pn_generator_rx : process(clk)
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
	end process sym_pn_generator_rx;

	com_pn_generator_rx : process(reg1_cur, reg2_cur, en)
	begin
		if en = '1' then
			reg1_next <= (reg1_cur(0) xor reg1_cur(3)) & reg1_cur(4 downto 1);
			reg2_next <= (reg2_cur(0) xor reg2_cur(1)
									  xor reg2_cur(3)
									  xor reg2_cur(4)) & reg2_cur(4 downto 1);
		else
			reg1_next <= reg1_cur;
			reg2_next <= reg2_cur;
		end if;
		if reg1_cur = FULL1 then
			syncha <= '1';
		else
			syncha <= '0';
		end if;
		-- ***************
		-- *** OUTPUTS ***
		-- ***************
		pn_ml1 	<= reg1_cur(0);
		pn_ml2 	<= reg2_cur(0);
		pn_gold <= reg1_cur(0) xor reg2_cur(0);	
	end process com_pn_generator_rx;
end behave;