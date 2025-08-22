
class alu_base extends uvm_test;

  `uvm_component_utils(alu_base)

 alu_environment alu_env;

  function new(string name = "alu_base",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    alu_env = alu_environment::type_id::create("alu_env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "alu_env.alu_active_agent", "is_active", UVM_ACTIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "alu_env.alu_passive_agent", "is_active", UVM_PASSIVE); 
    
  endfunction : build_phase

virtual function void end_of_elaboration();
 print();
endfunction


endclass 

class add_sub_test extends alu_base;

  `uvm_component_utils(add_sub_test)

  function new(string name = "add_sub_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    add_sub seq;
    phase.raise_objection(this);

    seq = add_sub::type_id::create("seq");
    seq.start(alu_env.alu_active_agent.alu_sequencer_1);
   
    phase.drop_objection(this);
  endtask

endclass

class arith_both_test extends alu_base;

  `uvm_component_utils(arith_both_test)

  function new(string name = "arith_both_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    arith_both seq;
    phase.raise_objection(this);

    seq = arith_both::type_id::create("seq");
    seq.start(alu_env.alu_active_agent.alu_sequencer_1);

    phase.drop_objection(this);
  endtask

endclass


class single_op_arith_test extends alu_base;

  `uvm_component_utils(single_op_arith_test)

  function new(string name = "single_op_arith_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    single_op_arith seq;
    phase.raise_objection(this);

    seq = single_op_arith::type_id::create("seq");
    seq.start(alu_env.alu_active_agent.alu_sequencer_1);

    phase.drop_objection(this);
  endtask

endclass

class cmd_out_of_order_test extends alu_base;

  `uvm_component_utils(cmd_out_of_order_test)

  function new(string name = "cmd_out_of_order_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    cmd_out_of_order seq;
    phase.raise_objection(this);

    seq = cmd_out_of_order::type_id::create("seq");
    seq.start(alu_env.alu_active_agent.alu_sequencer_1);

    phase.drop_objection(this);
  endtask

endclass

class check_ip_valid_test extends alu_base;

  `uvm_component_utils(check_ip_valid_test)

  function new(string name = "check_ip_valid_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    check_ip_valid seq;
    phase.raise_objection(this);
    repeat(1)begin
    seq =  check_ip_valid::type_id::create("seq");
      seq.start(alu_env.alu_active_agent.alu_sequencer_1);
    end
    phase.drop_objection(this);
  endtask

endclass


class check_16_test extends alu_base;

  `uvm_component_utils(check_16_test)

  function new(string name = "check_16_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    check_16 seq;
    phase.raise_objection(this);
    repeat(1)begin
    seq =  check_16::type_id::create("seq");
      seq.start(alu_env.alu_active_agent.alu_sequencer_1);
    end
    phase.drop_objection(this);
  endtask

endclass

class sing_op_logic_test extends alu_base;

  `uvm_component_utils(sing_op_logic_test)

  function new(string name = "sing_op_logic_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    sing_op_logic seq;
    phase.raise_objection(this);
    repeat(1)begin
    seq =  sing_op_logic::type_id::create("seq");
      seq.start(alu_env.alu_active_agent.alu_sequencer_1);
    end
    phase.drop_objection(this);
  endtask

endclass

class both_logic_operation_test extends alu_base;

  `uvm_component_utils(both_logic_operation_test)

  function new(string name = "both_logic_operation_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    both_logic_operation seq;
    phase.raise_objection(this);
    repeat(1)begin
    seq =  both_logic_operation::type_id::create("seq");
      seq.start(alu_env.alu_active_agent.alu_sequencer_1);
    end
    phase.drop_objection(this);
  endtask

endclass

class logic_rotate_test extends alu_base;

  `uvm_component_utils(logic_rotate_test)

  function new(string name = "logic_rotate_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    logic_rotate seq;
    phase.raise_objection(this);
    repeat(1)begin
      seq =  logic_rotate::type_id::create("seq");
      seq.start(alu_env.alu_active_agent.alu_sequencer_1);
    end
    phase.drop_objection(this);
  endtask

endclass

class ce_check_test extends alu_base;

  `uvm_component_utils(ce_check_test)

  function new(string name = "ce_check_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    ce_check seq;
    phase.raise_objection(this);
    repeat(1)begin
      seq = ce_check::type_id::create("seq");
      seq.start(alu_env.alu_active_agent.alu_sequencer_1);
    end
    phase.drop_objection(this);
  endtask

endclass

class alu_regression_test extends alu_base;

  `uvm_component_utils(alu_regression_test)

  function new(string name = "alu_regression_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_regression seq;
    phase.raise_objection(this);
    repeat(1000)begin
    seq =  alu_regression::type_id::create("seq");
      seq.start(alu_env.alu_active_agent.alu_sequencer_1);
    end
    phase.drop_objection(this);
  endtask

endclass
