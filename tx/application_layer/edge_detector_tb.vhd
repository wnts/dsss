library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity edge_detector_tb is
end edge_detector_tb;

architecture structural of edge_detector_tb is 


component edge_detector is
	port(clk		: in std_logic;	     		 
	     syncha		: in std_logic;
         edge		: out std_logic); 
end component;

for uut : edge_detector use entity work.edge_detector(behave);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk: 	 	std_logic;
signal syncha:  	std_logic;
signal edge: 	std_logic;

BEGIN

	uut: edge_detector PORT MAP(
      clk 		=> clk,      
      syncha 	=> syncha,
      edge 		=> edge);

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
   procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
     begin	  
      syncha  <= stimvect(0);   
       wait for period;
   end tbvector;
   BEGIN
      tbvector("X0");
	  tbvector("X0");
	  tbvector("X0");
	  tbvector("X1");
	  tbvector("X1");
	  tbvector("X1");
	  tbvector("X1");
	  tbvector("X0");
	  tbvector("X0");
	  tbvector("X0");
	  tbvector("X0");
	  tbvector("X1");
	  tbvector("X1");
	  tbvector("X1");
	  tbvector("X1");
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;





