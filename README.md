# CarrySelectAdderVHDL
A Carry Select Adder implemented using VHDL
A Carry Select adder is a parallel adder that optimises the operation compared to a simple Ripple Carry, focusing on the internal carries generated and propagated during the sum of the single bits. 

Key difference of a Carry Select logic is the division of the operation in blocks, specifically we’re diving the sum on N bits in P sums of operands with M bits. 

The **components** we’re going to use in this project are:
* Ripple Carry Adder (Generic implementation)
* Multiplexer 2to1

A carry select block has 
* 2 ripple carry adders with 3 inputs (A,B,c_in) where c_in is set to 0 for the first RCA and 1 for the second. This way the block is able to know beforehand the result of the sum in both cases (carry generated and carry propagated) and the selection of which result to give out and which carry to propagate (0 or 1) is left to the 2 multiplexers
* 2 multiplexers 2to1 that take as a select  signal the carry in coming from the previous block, in order to know if the carry was propagated or generated. 

Here is the schematic for the Carry Select Adder used to implement the VHDL code, with a structural architecture:

![picture](https://preview.ibb.co/iHsrrH/rtl.png)

## Entity
The entity declaration for the CarrySelectAdder component is the following:
```
 entity CARRYSELECT_ADDER is
  generic (
  			N: integer := 8; 	-- Inputs Parallelism
  			M: integer := 4 	--  Blocks Parallelism
   );
  port(
    A: in std_logic_vector (N-1 downto 0);
    B: in std_logic_vector (N-1 downto 0);
    C_in: in std_logic;
    SUM: out std_logic_vector (N-1 downto 0);
    overflow: out std_logic
  );
end CARRYSELECT_ADDER;
```
As it’s shown in the code the implementation is left generic so the the user can choose the type of operands. To test the circuit on the board we’ve chosen 8 bits operands in order to use the Switches available on the FPGA. 

Area and Timing tests have been done with bigger inputs in order to test the performance of the circuit. 


## Simulation
For the simulation we’ve used the ModelSIM simulator with Xilinx ISE, following the test bench with different test cases.

![picture](https://preview.ibb.co/efopBH/testbench.png)

### Simulation Test Cases
```
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
```
