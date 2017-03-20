library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dataregister_tb is
end dataregister_tb;

architecture structural of dataregister_tb is

	component dataregister is
		port(clk		: in std_logic;
			 ld			: in std_logic;
			 sh			: in std_logic;
			 data		: in std_logic_vector(3 downto 0);
			 sdo_posenc : out std_logic);
	end component;

	for uut : dataregister use entity work.dataregister(behave);

	constant period		: time := 100 ns;
	constant delay		: time :=  10 ns;
	signal end_of_sim	: boolean := false;

	signal clk, ld, sh, sdo_posenc 	: std_logic;
	signal data						: std_logic_vector(3 downto 0);

begin
	uut : dataregister
		port map(clk 		=> clk,
				 ld 		=> ld,
				 sh			=> sh,
				 data		=> data,
				 sdo_posenc => sdo_posenc);

	clock : process
	begin 
		clk <= '0';
		wait for period/2;
		loop
			clk <= '0';
			wait for period / 2;
			clk <= '1';
			wait for period / 2;
			exit when end_of_sim;
		end loop;
		wait;
	end process clock;

	tb : process
		procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0)) is
		begin
			ld <= stimvect(1);
			sh <= stimvect(0);
			wait for period;
		end tbvector;
	begin
		data <= "1101";
		-- load
		tbvector("10");
		-- 4x shiften
		tbvector("01");
		tbvector("01");
		tbvector("01");
		tbvector("01");
		-- aantal cycly niets doen
		tbvector("00");
		tbvector("00");
		tbvector("00");
		tbvector("00");
		-- load
		tbvector("10");
		-- 4x shiften
		tbvector("01");
		tbvector("01");
		tbvector("01");
		tbvector("01");	
		-- load en shift tegelijktertijd aansturen; load heeft prioriteit over shift
		tbvector("11");	
		tbvector("11");	

		end_of_sim <= true;
		wait;
	end process tb;
end;

