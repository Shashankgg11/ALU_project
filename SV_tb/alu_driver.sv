`include "define.sv"
class alu_driver;
  alu_transaction drv_trans, temp_trans;
  mailbox #(alu_transaction) mbx_gd;
  mailbox #(alu_transaction) mbx_dr;
  virtual alu_if.DRV vif;
  
  covergroup drv_cg;
    MODE_CP: coverpoint drv_trans.mode;
    INP_VALID_CP : coverpoint drv_trans.inp_valid;
    CMD_CP : coverpoint drv_trans.cmd { 
      bins valid_cmd[] = {[0:13]};
      ignore_bins invalid_cmd[] = {14, 15};  
    }
    OPA_CP : coverpoint drv_trans.opa { 
      bins all_zeros_a = {0};
      bins opa = {[0:`MAX]};
      bins all_ones_a = {`MAX};
    }
    OPB_CP : coverpoint drv_trans.opb { 
      bins all_zeros_b = {0};
      bins opb = {[0:`MAX]};
      bins all_ones_b = {`MAX};
    }
    CIN_CP : coverpoint drv_trans.cin;
    CMD_X_IP_V: cross CMD_CP, INP_VALID_CP;
    MODE_X_INP_V: cross MODE_CP, INP_VALID_CP;
    MODE_X_CMD: cross MODE_CP, CMD_CP;
    OPA_X_OPB : cross OPA_CP, OPB_CP;
  endgroup

  function new(mailbox #(alu_transaction)mbx_gd,
               mailbox #(alu_transaction) mbx_dr,
               virtual alu_if.DRV vif);
     this.mbx_gd=mbx_gd;
     this.mbx_dr=mbx_dr;
     this.vif=vif;
     drv_cg = new();
  endfunction
  
  function both_op(alu_transaction drv_trans);
    if(drv_trans.cmd == `ADD || drv_trans.cmd == `SUB || drv_trans.cmd == `ADD_CIN || drv_trans.cmd == `SUB_CIN || drv_trans.cmd == `CMP || drv_trans.cmd == `INC_MUL || drv_trans.cmd == `SHL1_A_MUL_B || drv_trans.cmd == `ADD_SIGN || drv_trans.cmd == `SUB_SIGN || drv_trans.cmd == `AND || drv_trans.cmd == `NAND || drv_trans.cmd == `OR || drv_trans.cmd == `XOR || drv_trans.cmd == `NOR || drv_trans.cmd == `XNOR || drv_trans.cmd == `ROL_A_B) return 1;
		else return 0;
	endfunction

  task start();
    repeat(3) @(vif.drv_cb);
    for(int i=0;i<`no_of_trans;i++)begin
		drv_trans=new();
		mbx_gd.get(drv_trans);
		if(both_op(drv_trans) && (drv_trans.inp_valid == 1 || drv_trans.inp_valid == 2 )) begin
			vif.drv_cb.opa<=drv_trans.opa;
			vif.drv_cb.opb<=drv_trans.opb;
			vif.drv_cb.cmd<=drv_trans.cmd;
			vif.drv_cb.ce<=drv_trans.ce;
			vif.drv_cb.inp_valid<=drv_trans.inp_valid;
			vif.drv_cb.mode<=drv_trans.mode;
			vif.drv_cb.cin<=drv_trans.cin;
			mbx_dr.put(drv_trans);
          	drv_cg.sample();
			$display("\n driver sent to interface opa=%d,opb=%d,cmd=%d,inp_valid=%d,ce=%d,cin=%d,mode=%d",drv_trans.opa,drv_trans.opb,drv_trans.cmd,drv_trans.inp_valid,drv_trans.ce,drv_trans.cin,drv_trans.mode,$time);
			repeat(2)@(vif.drv_cb);
			
			for(int i = 1;i < 16;i++)begin
			    temp_trans = new();
              	temp_trans.cmd = drv_trans.cmd;
              	temp_trans.mode = drv_trans.mode;
				temp_trans.cmd.rand_mode(0);
				temp_trans.mode.rand_mode(0);
				void'(temp_trans.randomize());
				$display("driver randomized when ip 1 or 2 opa=%d,opb=%d,cmd=%d,inp_valid=%d,ce=%d,cin=%d,mode=%d",temp_trans.opa,temp_trans.opb,temp_trans.cmd,temp_trans.inp_valid,temp_trans.ce,temp_trans.cin,temp_trans.mode,$time);
				begin
					vif.drv_cb.opa<=temp_trans.opa;
					vif.drv_cb.opb<=temp_trans.opb;
					vif.drv_cb.cmd<=temp_trans.cmd;
					vif.drv_cb.ce<=temp_trans.ce;
					vif.drv_cb.inp_valid<=temp_trans.inp_valid;
					vif.drv_cb.mode<=temp_trans.mode;	
					vif.drv_cb.cin<=temp_trans.cin;	
					mbx_dr.put(temp_trans);
                  	drv_cg.sample();
                    $display("coverage %d\n",drv_cg.get_coverage());
					$display("\n driver sent to interface opa=%d,opb=%d,cmd=%d,inp_valid=%d,ce=%d,cin=%d,mode=%d",temp_trans.opa,temp_trans.opb,temp_trans.cmd,temp_trans.inp_valid,temp_trans.ce,temp_trans.cin,temp_trans.mode,$time);
                  repeat(2)@(vif.drv_cb);
				end
				if(temp_trans.inp_valid == 3 || i == 15) begin
					break;
					temp_trans.cmd.rand_mode(1);
					temp_trans.mode.rand_mode(1);
				end
			end
		end
		else begin
			vif.drv_cb.opa<=drv_trans.opa;
			vif.drv_cb.opb<=drv_trans.opb;
			vif.drv_cb.cmd<=drv_trans.cmd;
			vif.drv_cb.ce<=drv_trans.ce;
			vif.drv_cb.inp_valid<=drv_trans.inp_valid;
			vif.drv_cb.mode<=drv_trans.mode;
			vif.drv_cb.cin<=drv_trans.cin;
			mbx_dr.put(drv_trans);
          	drv_cg.sample();
			$display("\n driver sent to interface opa=%d,opb=%d,cmd=%d,inp_valid=%d,ce=%d,cin=%d,mode=%d",drv_trans.opa,drv_trans.opb,drv_trans.cmd,drv_trans.inp_valid,drv_trans.ce,drv_trans.cin,drv_trans.mode,$time);
			repeat(2)@(vif.drv_cb);
		end
	end
	endtask
endclass
