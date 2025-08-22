`include "define.sv"
class alu_driver extends uvm_driver #(alu_sequence_item);

  virtual alu_if vif;

  `uvm_component_utils(alu_driver)
      
  function new (string name = "alu_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))

      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});

  endfunction
  
  function bit both_op(alu_sequence_item drv_trans);
	if(drv_trans.mode)begin
		if(drv_trans.cmd == `ADD || drv_trans.cmd == `SUB || drv_trans.cmd == `ADD_CIN || drv_trans.cmd == `SUB_CIN || drv_trans.cmd == `CMP || drv_trans.cmd == `INC_MUL || drv_trans.cmd == `SHL1_A_MUL_B) return 1;
		else return 0;
	end
	else begin
		if(drv_trans.cmd == `AND || drv_trans.cmd == `NAND || drv_trans.cmd == `OR || drv_trans.cmd == `XOR || drv_trans.cmd == `NOR || drv_trans.cmd == `XNOR || drv_trans.cmd == `ROL_A_B || drv_trans.cmd == `ROR_A_B) return 1;
		else return 0;
	end
	endfunction

  virtual task run_phase(uvm_phase phase);
    int i;
    bit [`cmd_width-1:0] hold_cmd; 
    bit hold_mode;
    bit hold_ce;
    forever begin
    seq_item_port.get_next_item(req);
      drive(req);
      `uvm_info(get_type_name(), "driver main stimulus sent", UVM_LOW)
      seq_item_port.item_done();
      if((req.inp_valid == 1 || req.inp_valid == 2) && both_op(req))begin
        hold_cmd = req.cmd;
        hold_mode = req.mode;
        hold_ce = req.ce;
        req.cmd.rand_mode(0);
        req.mode.rand_mode(0);
        req.ce.rand_mode(0);
        for(i = 0;i<16;i++)begin
          void'(req.randomize() with {cmd  == hold_cmd;mode == hold_mode;ce == hold_ce;});
          drive(req);
          `uvm_info(get_type_name(), "driver randomized stimulus sent", UVM_LOW)
          if(req.inp_valid == 3 || i==15)begin
            req.cmd.rand_mode(1);
            req.mode.rand_mode(1);
            req.ce.rand_mode(1);
            break;
          end
        end
      end
    end
  endtask 

  virtual task drive(alu_sequence_item req);
    @(vif.drv_cb);
      vif.opa <= req.opa;
      vif.opb <= req.opb;
      vif.inp_valid <= req.inp_valid;
      vif.ce <= req.ce;
      vif.cin <= req.cin;
      vif.mode <= req.mode;
      vif.cmd <= req.cmd;
      `uvm_info(get_type_name(), $sformatf("driver sent to intf sent opa = %0d opb = %0d inp=%0d cmd = %0d",req.opa,req.opb,req.inp_valid,req.cmd), UVM_LOW)
      req.print();
    repeat(2)@(vif.drv_cb);
  endtask
  
endclass
