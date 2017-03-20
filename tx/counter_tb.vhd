library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity counter_tb is
end counter_tb;

architecture structural of counter_tb is 

-- Component Declaration
component counter is
	port(clk, reset : in std_logic;
	     up, down: in std_logic;
	     count: out std_logic_vector(3 downto 0));
end component;

for uut : counter use entity work.counter(behave);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, reset:  std_logic;
signal up, down:  std_logic;
signal count : std_logic_vector(3 downto 0);

BEGIN
	uut: counter PORT MAP(
      clk => clk,
      reset => reset,
	  up => up,
	  down => down,
	  count => count);
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
	
tb : PROCESS
   procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0))is
     begin
      reset	<= stimvect(2);
      up 	<= stimvect(1);
	  down  <= stimvect(0);
   wait for period;
   end tbvector;
   BEGIN
	  -- reset
	  tbvector("100");
	  wait for period/2;
	  tbvector("010");
	  tbvector("010");
	  -- omhoog tellen van 0 tot 0 (van 0 tot 15, gevolgd door overflow)
	  for i in 1 to 16 loop
		  tbvector("010"); 
	  end loop;
	  -- even niets doen
	  tbvector("000");
	  wait for period*2;
	  -- omlaag tellen van 0 tot 0 (1 underflow en dan van 15 tot 0) 
	  for i in 1 to 16 loop
		  tbvector("001"); 
	  end loop;
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;




