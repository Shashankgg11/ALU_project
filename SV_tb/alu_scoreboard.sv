`include "define.sv"
class alu_scoreboard;
  alu_transaction ref2sb_trans,mon2sb_trans;
  mailbox #(alu_transaction) mbx_rs;
  mailbox #(alu_transaction) mbx_ms;
  int MATCH,MISMATCH;
  function new(mailbox #(alu_transaction) mbx_rs,
               mailbox #(alu_transaction) mbx_ms
              );
    this.mbx_rs=mbx_rs;
    this.mbx_ms=mbx_ms;
  endfunction
  task start();
    //int count;
    //count = 0;
    for(int i=0;i<`no_of_trans;i++) begin
      ref2sb_trans=new();
      mon2sb_trans=new();
      //fork
          begin
           mbx_ms.get(mon2sb_trans);
            $display("scoreboard received from monitor res=%d,err=%d,oflow=%d,cout=%d,g=%d,l=%d,e=%d inp_valid=%d i=%d",mon2sb_trans.res,mon2sb_trans.err,mon2sb_trans.oflow,mon2sb_trans.cout,mon2sb_trans.g,mon2sb_trans.l,mon2sb_trans.e,mon2sb_trans.inp_valid,i,$time);
          end
          begin
           mbx_rs.get(ref2sb_trans);
            $display("scoreboard receieved from ref res=%d,err=%d,oflow=%d,cout=%d,g=%d,l=%d,e=%d ",ref2sb_trans.res,ref2sb_trans.err,ref2sb_trans.oflow,ref2sb_trans.cout,ref2sb_trans.g,ref2sb_trans.l,ref2sb_trans.e,$time);
          end	
	//join
	/* if(mon2sb_trans.inp_valid == 1 || mon2sb_trans.inp_valid == 2)begin
        count++;
        if(count>16) count = 0;
        else i--;
      end
      if(i > `no_of_trans-1)break;*/
      compare_report();
    end
  endtask

task compare_report();
  if({ref2sb_trans.res,ref2sb_trans.err,ref2sb_trans.oflow,ref2sb_trans.cout,ref2sb_trans.g,ref2sb_trans.l,ref2sb_trans.e} === {mon2sb_trans.res,mon2sb_trans.err,mon2sb_trans.oflow,mon2sb_trans.cout,mon2sb_trans.g,mon2sb_trans.l,mon2sb_trans.e})
          begin
            MATCH++;
            $display("scoreboard ref_res=%d,ref_err=%d,ref_oflow=%d,ref_cout=%d,ref_g=%d,ref_l=%d,ref_e=%d mon_res=%d,mon_err=%d,mon_oflow=%d,mon_cout=%d,mon_g=%d,mon_l=%d,mon_e=%d  ",ref2sb_trans.res,ref2sb_trans.err,ref2sb_trans.oflow,ref2sb_trans.cout,ref2sb_trans.g,ref2sb_trans.l,ref2sb_trans.e,mon2sb_trans.res,mon2sb_trans.err,mon2sb_trans.err,mon2sb_trans.oflow,mon2sb_trans.cout,mon2sb_trans.g,mon2sb_trans.l,mon2sb_trans.e,$time);
            $display("DATA MATCH SUCCESSFUL MATCH=%d",MATCH);
          end
        else
          begin
            $display("scoreboard ref_res=%d,ref_err=%d,ref_oflow=%d,ref_cout=%d,ref_g=%d,ref_l=%d,ref_e=%d mon_res=%d,mon_err=%d,mon_oflow=%d,mon_cout=%d,mon_g=%d,mon_l=%d,mon_e=%d  ",ref2sb_trans.res,ref2sb_trans.err,ref2sb_trans.oflow,ref2sb_trans.cout,ref2sb_trans.g,ref2sb_trans.l,ref2sb_trans.e,mon2sb_trans.res,mon2sb_trans.err,mon2sb_trans.err,mon2sb_trans.oflow,mon2sb_trans.cout,mon2sb_trans.g,mon2sb_trans.l,mon2sb_trans.e,$time);
            MISMATCH++;
            $display("DATA MATCH FAILED MISMATCH=%d",MISMATCH);
          end
endtask
endclass
