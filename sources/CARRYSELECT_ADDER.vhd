library ieee;
use ieee.STD_LOGIC_1164.all;

entity CARRYSELECT_ADDER is
  generic (
  			N: integer := 8; 	-- Dimensione degli ingressi in bit
  			M: integer := 4 	--  Numero di bit per ogni blocco
   );
  port(
    A: in std_logic_vector (N-1 downto 0);
    B: in std_logic_vector (N-1 downto 0);
    C_in: in std_logic;
    SUM: out std_logic_vector (N-1 downto 0);
    overflow: out std_logic
  );
end CARRYSELECT_ADDER;

architecture behavioral of CARRYSELECT_ADDER is
  -- componenti

  -- blocco composto da 2 RCA
  component BLOCCORCA is
  	generic(WIDTH : integer := M );
  	Port(
  			X: in std_logic_vector(WIDTH-1 downto 0);
  			Y: in std_logic_vector(WIDTH-1 downto 0);
  			carry_in: in std_logic;
  			carry_out: out std_logic;
  			S: out std_logic_vector(WIDTH-1 downto 0)
  	);
  end component;

  -- singolo RCA, necessario per il primo stadio
  component RCADDER is
    generic ( WIDTH : natural := M );
    port (
      X  : in std_logic_vector(WIDTH-1 downto 0);
      Y  : in std_logic_vector(WIDTH-1 downto 0);
      C_in : in std_logic;
      --
      RESULT   : out std_logic_vector(WIDTH-1 downto 0);
      OVERFLOW  : out std_logic
      );
  end component;

  -- creiamo 'p' ripple carry adder a 'm' bit
  -- in particolare p viene scelto come p =
  constant P : integer := N/M;

  -- segnali d'appoggio
  signal output_finale : std_logic_vector(N-1 downto 0); -- uscita di tutto il Carry Select
  signal carry_out_blocchi : std_logic_vector(P-1 downto 0); -- vettore per gestire i riporti

  begin
    -- iniziamo creando il primo blocco che è diverso ed è solo un RCA
    -- avente M bit di ingresso per X e Y
    PRIMO_RCA: RCADDER generic map (WIDTH => M)
      port map(
        X => A (M-1 downto 0) ,
        Y => B (M-1 downto 0) ,
        C_in => C_in  , -- primo carry
        --
        RESULT => output_finale(M-1 downto 0) ,
        OVERFLOW => carry_out_blocchi(0) -- Primo riporto
      );

      -- generiamo i restanti P-1 blocchi RCA

     ALTRI_BLOCCHI: for i in 1 to P-1 generate
      BLOCK1: BLOCCORCA generic map (WIDTH => M)
        port map (
          X => A ((i+1)*M-1 downto i*M), -- per dividere i vettori a N bit in P-1 vettori a M bit
          Y => B ((i+1)*M-1 downto i*M),
          carry_in => carry_out_blocchi(i-1),
          --
          carry_out => carry_out_blocchi(i),
          S => output_finale (M*(i+1)-1 downto M*i)
        );
      end generate ALTRI_BLOCCHI;

      SUM <= output_finale;
      overflow <= carry_out_blocchi(P-1);

end behavioral;
