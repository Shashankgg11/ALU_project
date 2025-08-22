`include "define.sv"
interface alu_if(input bit clk,rst);
  logic [`width-1:0] opa,opb;
  logic [`cmd_width-1:0]cmd;
  logic [1:0]inp_valid;
  logic ce,cin,mode;

  logic err,oflow,cout,g,l,e;
  logic [`width+1:0] res;

  clocking drv_cb@(posedge clk);
    default input #0 output #0;
    output opa,opb,cmd,inp_valid,ce,cin,mode;
  endclocking

  clocking mon_cb@(posedge clk);
    default input #0 output #0;
    input  err,oflow,cout,g,l,e,res;
    input opa, opb, inp_valid, mode, cin, ce, cmd;
  endclocking

  modport DRV (clocking drv_cb);
  modport MON(clocking mon_cb);
    
  property clk_valid_check;
    @(posedge clk) !$isunknown(clk);
  	endproperty
  	assert property (clk_valid_check)
    else $error("[ASSERTION] Clock signal is unknown at time %0t", $time);
      
      property Reset_signal_check;
        @(posedge clk) rst |=> (res === 9'bz && err === 1'bz && e === 1'bz && g === 1'bz && l === 1'bz && cout === 1'bz && oflow === 1'bz);
    endproperty
    assert property(Reset_signal_check)
        $display("RST assertion PASSED at time %0t", $time);
    else
        $info("RST assertion FAILED @ time %0t", $time);

    property ppt_timeout_arithmetic;
      @(posedge clk) disable iff(rst) (ce && (cmd == `ADD || cmd == `SUB || cmd == `ADD_CIN || cmd == `SUB_CIN || cmd == `SHL1_A_MUL_B || cmd == `INC_MUL) && (inp_valid == 2'b01 || inp_valid == 2'b10)) |-> ##16 (err == 1'b1);
    endproperty
    assert property(ppt_timeout_arithmetic)
        $display("TIMEOUT FOR ARITHMETIC assertion PASSED at time %0t", $time);
    else
        $warning("Timeout assertion failed at time %0t", $time);

    property ppt_timeout_logical;
      @(posedge clk) disable iff(rst) (ce && (cmd == `AND || cmd == `OR || cmd == `NAND || cmd == `XOR || cmd == `XNOR || cmd == `NOR || cmd == `ROR_A_B  || cmd == `ROL_A_B) && (inp_valid == 2'b01 || inp_valid == 2'b10)) |-> ##16 (err == 1'b1);
    endproperty
    assert property(ppt_timeout_logical)
        $display("TIMEOUT FOR LOGICAL assertion PASSED at time %0t", $time);
    else
        $warning("Timeout assertion failed at time %0t", $time);

      assert property (@(posedge clk) disable iff(rst) (ce && mode && inp_valid ==2'b11 && (cmd == `ROR_A_B || cmd == `ROL_A_B) && opb > (`width - 1) |-> ##[1:3] err))
      $display("ROR ERROR assertion PASSED at time %0t", $time);
    else
        $info("NO ERROR FLAG RAISED");

    property CMD_validation_arithmetic;
      @(posedge clk)disable iff(rst) (mode && cmd > 10) |-> ##1 err;
    endproperty
    assert property (CMD_validation_arithmetic)
        $display("CMD out of range fr arithmetic assertion PASSED at time %0t", $time);
    else
        $info("CMD INVALID ERR NOT RAISED");

    //5. CMD out of range logical
    property CMD_validation_logical;
      @(posedge clk) disable iff(rst)(!mode && cmd > 13) |-> ##1 err;
    endproperty
    assert property (CMD_validation_logical)
        $info("CMD out of range for logical assertion PASSED at time %0t", $time);
    else
        $info("CMD INVALID ERR NOT RAISED");

    // 7. INP_VALID 00 case
    property Error_detection_in_inp_valid_00;
      @(posedge clk) disable iff(rst) (inp_valid == 2'b00) |-> ##1 err;
    endproperty
    assert property ( Error_detection_in_inp_valid_00)
        $display("INP_VALID 00  assertion PASSED at time %0t", $time);
    else
        $info("ERROR NOT raised");

    //8. CE assertion
    property Clock_enable_functionality;
      @(posedge clk) disable iff(rst) !ce |-> ##1 ($stable(res) && $stable(cout) && $stable(oflow) && $stable(g) && $stable(l) && $stable(e) && $stable(err));
    endproperty
    assert property(Clock_enable_functionality)
        $display("ENABLE  assertion PASSED at time %0t", $time);
    else
        $info("Clock enable assertion failed at time %0t", $time);
      
      property VALID_INPUTS_CHECK;
        @(posedge clk) disable iff(rst) ce |-> not($isunknown({opa,opb,inp_valid,cin,mode,cmd}));
endproperty

assert property(VALID_INPUTS_CHECK)
$info("inputs valid");
  else
    $info("inputs not valid");
    
  
   property rst_valid_check;
     @(posedge clk) !$isunknown(rst);
  endproperty
  assert property (rst_valid_check)
    else $error("[ASSERTION] Reset signal is unknown at time %0t", $time);
    
 endinterface
