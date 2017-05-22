library ieee;
use ieee.std_logic_1164.all;
entity dataregister is
	port(clk		: in std_logic;
		 ld			: in std_logic;
		 sh			: in std_logic;
		 data		: in std_logic_vector(3 downto 0);
		 sdo_posenc : out std_logic);
end dataregister;

architecture behave of dataregister is
	constant PREAMBLE : std_logic_vector(6 downto 0) := "0111110";
	signal reg_cur, reg_next : std_logic_vector(10 downto 0) := (others => '0');
begin
	syn_dataregister : process(clk)
	begin
		if rising_edge(clk) then
			reg_cur <= reg_next;
		end if;
	end process syn_dataregister;

	com_dataregister : process(reg_cur, sh, ld, data)
	begin
		if ld = '1' then
			reg_next <= PREAMBLE & data;
		elsif sh = '1' then
			reg_next <= reg_cur(9 downto 0) & '0';
		else
			reg_next <= reg_cur;
		end if;
		sdo_posenc <= reg_cur(10);
	end process com_dataregister;
end behave;
