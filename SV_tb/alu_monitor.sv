`include "define.sv"
class alu_monitor;
covergroup mon_cg;
	result : coverpoint mon_trans.res {bins res_r = {[0:(2**(`width+2))-1]};
					   bins res_0 = {0};
					   bins res_m = {{(`width+1){1'b1}}};
						}
	error  : coverpoint mon_trans.err { bins err[] = {0,1};}
	cout   : coverpoint mon_trans.cout{ bins carry[] = {0,1};}
	equal  : coverpoint mon_trans.e { bins e[] = {0,1};}
	great  : coverpoint mon_trans.g { bins g[] = {0,1};}
	less   : coverpoint mon_trans.l { bins l[] = {0,1};} 
endgroup
  alu_transaction mon_trans;
  mailbox #(alu_transaction)mbx_ms;
  virtual alu_if.MON vif;
  function new( virtual alu_if.MON vif, mailbox #(alu_transaction)mbx_ms);
    this.mbx_ms=mbx_ms;
    this.vif=vif;
    mon_cg = new();
  endfunction

  task start();
    //int count;
    //count = 0;
    repeat(5)@(vif.mon_cb);
    for(int i=0;i<`no_of_trans;i++)
    begin
      mon_trans=new();
      repeat(1)@(vif.mon_cb)begin
        mon_trans.res=vif.mon_cb.res;
        mon_trans.err=vif.mon_cb.err;
        mon_trans.oflow=vif.mon_cb.oflow;
        mon_trans.cout=vif.mon_cb.cout;
        mon_trans.g=vif.mon_cb.g;
        mon_trans.l=vif.mon_cb.l;
        mon_trans.e=vif.mon_cb.e;
	mon_trans.inp_valid=vif.mon_cb.inp_valid;
      end
  /*    if(mon_trans.inp_valid == 1 || mon_trans.inp_valid == 2)begin
	count++;
	if(count>16) count = 0;
	else i--;
      end*/
      $display("monitor passing the data to scoreboard res=%d,err=%d,oflow=%d,cout=%d,g=%d,l=%d,e=%d inp_valid = %d i=%d",mon_trans.res,mon_trans.err,mon_trans.oflow,mon_trans.cout,mon_trans.g,mon_trans.l,mon_trans.e,mon_trans.inp_valid,i,$time);
      mbx_ms.put(mon_trans);
	mon_cg.sample();
      repeat(1) @(vif.mon_cb);
	//if(i>`no_of_trans-1) break;
    end
  endtask
endclass
