library ieee;
use ieee.std_logic_1164.all;

entity matched_filter is
	port(clk		: in std_logic;	     		 
		 reset		: in std_logic;
		 ce			: in std_logic;
		 sdi_spread	: in std_logic;
		 sel		: in std_logic_vector(1 downto 0);
		 seq_det	: out std_logic);
end matched_filter;

architecture behave of matched_filter is	
	constant no_ptrn   : std_logic_vector(30 downto 0) := (others => '0');
	constant ml1_ptrn  : std_logic_vector(30 downto 0) := "1101110011111100011011101010001";
	constant ml2_ptrn  : std_logic_vector(30 downto 0) := "1001101111101000100101011000011";
	constant gold_ptrn : std_logic_vector(30 downto 0) := ml1_ptrn xor ml2_ptrn;
	signal pn_ptrn 	   : std_logic_vector(30 downto 0);
	signal present_reg, next_reg : std_logic_vector(30 downto 0) := (others => '0');
begin
	syn_matched_filter : process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				present_reg <= (others => '1');
			elsif ce = '1' then
				present_reg <= next_reg;
			end if;
		end if;	
	end process syn_matched_filter;

	com_matched_filter : process(sdi_spread, present_reg, sel, pn_ptrn)
	begin
		next_reg <= sdi_spread & present_reg(30 downto 1);
		-- output	
		case sel is
			when "00" => 
				pn_ptrn <= no_ptrn;
			when "01" => 
				pn_ptrn <= ml1_ptrn;
			when "10" => 
				pn_ptrn <= ml2_ptrn;
			when "11" => 
				pn_ptrn <= gold_ptrn;
			when others =>
				pn_ptrn <= no_ptrn;
		end case;
		if  present_reg = pn_ptrn then
			seq_det <= '1';
		else
			seq_det <= '0';
		end if;
	end process com_matched_filter;
end behave;