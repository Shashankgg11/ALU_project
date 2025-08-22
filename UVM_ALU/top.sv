`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "alu_pkg.sv"
`include "alu_interface.sv"
`include "design.sv"
module top;
  import uvm_pkg::*;  
  import alu_pkg::*;
 
  bit clk;
  bit reset;
  
  always #5 clk = ~clk;
  
  initial begin
    reset = 1;
    #5 reset =0;
  end
  alu_if intrf(clk,reset);
  
  ALU_DESIGN #(.DW(`width),.CW(`cmd_width)) DUV(.OPA(intrf.opa),.OPB(intrf.opb),.CMD(intrf.cmd),.CE(intrf.ce),.MODE(intrf.mode),.CIN(intrf.cin),.INP_VALID(intrf.inp_valid),.RES(intrf.res),.COUT(intrf.cout),.OFLOW(intrf.oflow),.G(intrf.g),.L(intrf.l),.E(intrf.e),.ERR(intrf.err),.CLK(intrf.clk),.RST(reset));
  
  initial begin 
    uvm_config_db#(virtual alu_if)::set(uvm_root::get(),"*","vif",intrf);
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end
  
  initial begin 
    run_test("alu_regression_test");
    #1000 $finish;
  end
endmodule
