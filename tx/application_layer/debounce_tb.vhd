library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity debouncer_tb is
end debouncer_tb;

architecture structural of debouncer_tb is 

-- Component Declaration
component debouncer
port (
	clk: in std_logic;
	reset: in std_logic;
	cha: in std_logic;
	syncha: out std_logic
  );
end component;

for uut : debouncer use entity work.debouncer(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:  std_logic;
signal reset:  std_logic;
signal cha:  std_logic;
signal syncha: std_logic;

BEGIN

	uut: debouncer PORT MAP(
      clk => clk,
      reset => reset,
      cha => cha,
      syncha => syncha);

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
      cha <= stimvect(1);
      reset <= stimvect(0);

       wait for period;
   end tbvector;
   BEGIN
      wait for delay; -- inputs uit fase met clk (meer realistisch voor debouncer, input is asynchroon (gebruiker))
      tbvector("01"); -- reset
      tbvector("10"); -- aantal clk cycli dender
      tbvector("00");
      tbvector("10");
      tbvector("00");
      tbvector("10");
      tbvector("10"); -- houdt ingang 5 clock cycli stabiel hoog
      tbvector("10");
      tbvector("10");
      tbvector("10");
      tbvector("10");
      tbvector("10"); -- aantal clk cycli dender
      tbvector("00");
      tbvector("10");
      tbvector("00");
      tbvector("10");
      tbvector("00"); -- houdt ingang 5 clock cycli stabiel laag
      tbvector("00");
      tbvector("00");
      tbvector("00");
      tbvector("00");
      tbvector("00"); -- aantal clk cycli dender
      tbvector("00");
      tbvector("10");
      tbvector("00");
      tbvector("10");
	

      
            
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;




