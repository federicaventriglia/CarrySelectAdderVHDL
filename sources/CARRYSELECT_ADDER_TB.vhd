--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:05:38 11/27/2017
-- Design Name:   
-- Module Name:   C:/Users/IEUser/Desktop/EserciziISE/CARRY_SELECT_ADDER/CARRYSELECT_ADDER_TB.vhd
-- Project Name:  CARRY_SELECT_ADDER
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CARRYSELECT_ADDER
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CARRYSELECT_ADDER_TB IS
END CARRYSELECT_ADDER_TB;
 
ARCHITECTURE behavior OF CARRYSELECT_ADDER_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component CARRYSELECT_ADDER is
    generic (
      N : natural := 4;
      M : natural := 2
      );
    port (
      A  : in std_logic_vector(N-1 downto 0);
      B  : in std_logic_vector(N-1 downto 0);
      C_in : in std_logic;
      --
      SUM   : out std_logic_vector(N-1 downto 0);
      OVERFLOW  : out std_logic
      );
  end component;
    
	--Constants
	constant t_N: integer := 64;
	constant t_M: integer := 8;

   --Inputs
   signal X_reg : std_logic_vector(t_N-1 downto 0) := (others => '0');
   signal Y_reg : std_logic_vector(t_N-1 downto 0) := (others => '0');
   signal C_in_reg : std_logic := '0';

 	--Outputs
   signal SUM_reg : std_logic_vector(t_N-1 downto 0);
   signal overflow_reg : std_logic;
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CARRYSELECT_ADDER GENERIC MAP(
			N => t_N,
			M => t_M
		)
		PORT MAP (
          A => X_reg,
          B => Y_reg,
          C_in => C_in_reg,
          SUM => SUM_reg,
          overflow => overflow_reg
        );

 
   -- Stimulus process
   stim_proc: process
       --variable to track errors
       variable errCnt : integer := 0;
    begin
       --TEST 1
       X_reg(3 downto 0) <= "0000";
       Y_reg(3 downto 0) <= "0001";
       wait for 15 ns;
       assert(SUM_reg(3 downto 0) = "0001")
       report "Error SUM not 0001" severity error;
       assert(OVERFLOW_reg = '0')
       report "Error OVERFLOW 1" severity error;
       if(SUM_reg (3 downto 0) /= "0001" or OVERFLOW_reg /= '0') then
          errCnt := errCnt + 1;
       end if;

   	 --TEST 2
       X_reg (3 downto 0) <= "0001";
       Y_reg (3 downto 0) <= "0011";
       wait for 15 ns;
       assert(SUM_reg (3 downto 0) = "0100")
       report "Error SUM not 0100" severity error;
       assert(OVERFLOW_reg = '0')
       report "Error OVERFLOW 1" severity error;
       if(SUM_reg /= "0100" or OVERFLOW_reg /= '0') then
          errCnt := errCnt + 1;
       end if;

--       --TEST 3
--       X_reg  <= "1010";
--       Y_reg <= "0101";
--       wait for 15 ns;
--       assert(SUM_reg = "1111")
--       report "Error SUM not 1111" severity error;
--       assert(OVERFLOW_reg = '0')
--       report "Error OVERFLOW 1" severity error;
--       if(SUM_reg /= "1111" or OVERFLOW_reg /= '0') then
--          errCnt := errCnt + 1;
--       end if;
--
-- 	   --TEST 4
--       X_reg <= "0011";
--       Y_reg <= "1000";
--       wait for 15 ns;
--       assert(SUM_reg = "1011")
--       report "Error SUM not 1011" severity error;
--       assert(OVERFLOW_reg = '0')
--       report "Error OVERFLOW 1" severity error;
--       if(SUM_reg /= "1011" or OVERFLOW_reg /= '0') then
--          errCnt := errCnt + 1;
--       end if;
--
--       --TEST 5
--         X_reg <= "1111";
--         Y_reg <= "1000";
--         wait for 15 ns;
--         assert(SUM_reg = "0111")
--         report "Error SUM not 1011" severity error;
--         assert(OVERFLOW_reg = '1')
--         report "Error OVERFLOW NOT 1" severity error;
--         if(SUM_reg /= "0111" or OVERFLOW_reg /= '0') then
--            errCnt := errCnt + 1;
--         end if;
--
--       --TEST 6
--         X_reg <= "1111";
--         Y_reg <= "1110";
--         wait for 15 ns;
--         assert(SUM_reg = "1101")
--         report "Error SUM not 1011" severity error;
--         assert(OVERFLOW_reg = '1')
--         report "Error OVERFLOW NOT 1" severity error;
--         if(SUM_reg /= "0111" or OVERFLOW_reg /= '0') then
--            errCnt := errCnt + 1;
--         end if;

 	  -------------- SUMMARY -------------
       if(errCnt = 0) then
          assert false report "Good!"  severity note;
       else
          assert true report "Error!"  severity error;
       end if;
 	  wait;
   end process;

END;
