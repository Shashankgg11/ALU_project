

class alu_monitor extends uvm_monitor;

  virtual alu_if vif;

  uvm_analysis_port #(alu_sequence_item) item_collected_port;

  alu_sequence_item alu_sequence_item_1;

  `uvm_component_utils(alu_monitor)

  function new (string name = "alu_monitor", uvm_component parent);
    super.new(name, parent);
    alu_sequence_item_1 = new();
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    //@(vif.mon_cb);
    forever begin
      repeat(3)@(vif.mon_cb);
       alu_sequence_item_1.res = vif.res;
       alu_sequence_item_1.err = vif.err;
       alu_sequence_item_1.cout = vif.cout;
       alu_sequence_item_1.oflow = vif.oflow;
       alu_sequence_item_1.g = vif.g;
       alu_sequence_item_1.e = vif.e;
       alu_sequence_item_1.l = vif.l;
       alu_sequence_item_1.opa = vif.opa;
       alu_sequence_item_1.opb = vif.opb;
       alu_sequence_item_1.inp_valid = vif.inp_valid;
       alu_sequence_item_1.cin = vif.cin;
       alu_sequence_item_1.mode = vif.mode;
       alu_sequence_item_1.cmd = vif.cmd;
       alu_sequence_item_1.ce = vif.ce;
      
      
      `uvm_info(get_type_name(), $sformatf("monitor sent to sb from intf res = %0d err = %0d cout=%0d oflow = %0d",vif.res,vif.err,vif.cout,vif.oflow), UVM_LOW)
      
      item_collected_port.write(alu_sequence_item_1);
      alu_sequence_item_1.print();
      //repeat(1)@(vif.mon_cb);
    end 
  endtask

endclass
