`include "define.sv"
interface alu_if(input bit clk,rst);
  logic [`width-1:0] opa,opb;
  logic [`cmd_width-1:0]cmd;
  logic [1:0]inp_valid;
  logic ce,cin,mode;
  ///outputs
  logic err,oflow,cout,g,l,e;
  logic [`width+1:0] res;
  ///clocking block

  //clocking block driver
  clocking drv_cb@(posedge clk);
    default input #0 output #0;
    output opa,opb,cmd,inp_valid,ce,cin,mode;
    input rst;
  endclocking

  //clocking block monitor
  clocking mon_cb@(posedge clk);
    default input #0 output #0;
    input  err,oflow,cout,g,l,e,res,inp_valid;
  endclocking

  //clocking block reference
   clocking ref_cb@(posedge clk);
    default input #0 output #0;
     input rst;
   endclocking
/*property ppt_reset;
  @(posedge clk) rst |=> ##[1:3] 
    (res === 9'bz && err === 1'bz && e === 1'bz && g === 1'bz && l === 1'bz && cout === 1'bz && oflow === 1'bz);
endproperty

assert property(ppt_reset)
  $display("RST assertion PASSED at time %0t", $time);
else
  $info("RST assertion FAILED @ time %0t", $time);

property wait_16;
  @(posedge clk) disable iff(rst) (ce && inp_valid == 2'b01) |-> ##16 (err == 1'b1);
endproperty

assert property(wait_16)
  else $error("Timeout assertion failed at time %0t", $time);

assert property (
  @(posedge clk) disable iff(rst) 
  (ce && mode && (cmd == 12 || cmd == 13) && opb > {($clog2(`width)){1'b1}}) 
  |=> ##[1:3] err
)
else $info("NO ERROR FLAG RAISED");

assert property (
  @(posedge clk) disable iff(rst) 
  (mode && cmd > 12) 
  |=> ##[1:2] err
)
else $info("CMD INVALID ERR NOT RAISED");

assert property (
  @(posedge clk) disable iff(rst)
  (!mode && cmd > 13) 
  |=> ##[1:2] err
)
else $info("CMD INVALID ERR NOT RAISED");

property ppt_valid_inp_valid;
  @(posedge clk) disable iff(rst)
  (inp_valid inside {2'b00, 2'b01, 2'b10, 2'b11});
endproperty

assert property(ppt_valid_inp_valid)
  else $info("Invalid INP_VALID value: %b at time %0t", inp_valid, $time);

assert property (
  @(posedge clk) disable iff(rst) 
  (inp_valid == 2'b00) 
  |=> err
)
else $info("ERROR NOT raised");

property ppt_clock_enable;
  @(posedge clk) disable iff(rst)
  (!ce) |-> ##1 ($stable(res) && $stable(cout) && $stable(oflow) &&
                 $stable(g) && $stable(l) && $stable(e) && $stable(err));
endproperty

assert property(ppt_clock_enable)
  else $info("Clock enable assertion failed at time %0t", $time);*/


  modport DRV (
    clocking drv_cb,
    output opa, opb, cmd, inp_valid, ce, cin, mode);
  modport MON(clocking mon_cb);
  modport REF_SB(clocking ref_cb);

 endinterface
