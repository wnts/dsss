library ieee;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity shift_register_tb is
end shift_register_tb;

architecture structural of shift_register_tb is 


component shift_register is
	generic (N 		: natural := 31);
	port(clk		: in std_logic;	     		 
	     reset		: in std_logic;		 
		 sdi		: in std_logic;
		 sdo		: out std_logic);
end component;

for uut : shift_register use entity work.shift_register(behave);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
-- breedte shift_register (in bits)
constant N		: positive := 31;
signal end_of_sim : boolean := false;

signal clk		: 	std_logic;
signal reset	:	std_logic;
signal sdi, sdo : 	std_logic;
constant testdata : std_logic_vector := "11101001";

begin
	uut : shift_register
		generic map(N => testdata'length)
    	port map(clk 	=> clk,      
	             reset	=> reset,
				 sdi	=> sdi,
				 sdo 	=> sdo);
	clock : process
	begin 
    	clk <= '0';
        wait for period/2;
	    loop
        	clk <= '0';
	        wait for period/2;
	        clk <= '1';
	        wait for period/2;
	        exit when end_of_sim;
        end loop;
   		wait;
    end process clock;
	
    tb : process
    	procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
		begin	  
			reset  <= stimvect(1);   
			sdi	   <= stimvect(0);
			wait for period;
		end tbvector;	
		variable seed1, seed2: positive;
		variable rand : real;
	begin
		-- genereer random testdata vector
		-- onderstaand is pure overkill, maar was leuk om eens uit te pluizen
		-- 		Met uniform() wordt eerst een willekeurige real tussen 0.0 en 1.0
		-- 		gegenereerd en in variabele rand gestoken.
		--		Vervolgens wordt rand vermenigvuldigd met 2^N om een N-bit getal te verkrijgen 
		--		Dit wordt dan omgezet naar een std_logic_vector en in de for loop aan het schuifregister gevoed
		--
		--		!! DIT WERKT NIET !! 
		--		seed1 en seed2 moeten worden geinitialiseerd worden met een
		--		waarde die zelf redelijk willekeurig is, bvb unix timestamp op ogenblik van simulatie. Maar ik vind geen
		--		manier om hier aan te geraken (er is geen time() functie oid)
		--		RESULTAAT: zonder deftige seed returned uniform altijd hetzelfde getal bij eerste aanroep 
--		uniform(seed1, seed2, rand);
--		report "Random number (real) = " & real'image(rand);
--		report "Random number (scaled, real) = " & real'image(rand * 2.0 ** real(N));
--		report "Random number (integer) = " & integer'image(integer(rand * 2.0 ** real(N)));
--		testdata := std_logic_vector(conv_signed(integer(rand * 2.0 ** real(N)), N));
		-- reset twee clk cycles
		tbvector("10");
		tbvector("10");
		-- shift testdata in
		for i in 0 to testdata'length - 1
		loop
			tbvector("0" & testdata(i));
		end loop; 		
		-- shift nog wat verder nullen in
		for i in 0 to testdata'length - 1
		loop
			tbvector("00");
		end loop; 		
        end_of_sim <= true;
        wait;
    end process;
end;