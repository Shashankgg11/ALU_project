`include "design.sv"
`include "alu_pkg.sv"
`include "alu_if.sv"
`include "define.sv"
module top( );
    import alu_pkg::*;
    bit clk;
    bit reset;

  //Generating the clock
  initial
    begin
     forever #10 clk=~clk;
    end
  //Asserting and de-asserting the reset
  initial
    begin
      @(posedge clk);
      reset=1;
      repeat(1)@(posedge clk);
      reset=0;
    end

  //Instantiating the interface
  alu_if intrf(clk, reset);
  //Instantiating the DUV
  ALU_DESIGN #(.DW(`width),.CW(`cmd_width)) DUV(.OPA(intrf.opa),.OPB(intrf.opb),.CMD(intrf.cmd),.CE(intrf.ce),.MODE(intrf.mode),.CIN(intrf.cin),.INP_VALID(intrf.inp_valid),.RES(intrf.res),.COUT(intrf.cout),.OFLOW(intrf.oflow),.G(intrf.g),.L(intrf.l),.E(intrf.e),.ERR(intrf.err),.CLK(intrf.clk),.RST(reset));
  //Instantiating the Test
     alu_test tb= new(intrf.DRV,intrf.MON,intrf.REF_SB);
    // test1 tb1= new(intrf.DRV,intrf.MON,intrf.REF_SB);
 //	test2 tb2= new(intrf.DRV,intrf.MON,intrf.REF_SB);
   //  test3 tb3= new(intrf.DRV,intrf.MON,intrf.REF_SB);
 //	test4 tb4= new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test_regression tb_regression= new(intrf.DRV,intrf.MON,intrf.REF_SB);

  initial
   begin
    tb_regression.run();
    tb.run();
    $finish();
   end
endmodule
