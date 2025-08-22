
class alu_sequence extends uvm_sequence#(alu_sequence_item);
  
  `uvm_object_utils(alu_sequence)
  function new(string name = "alu_sequence");
    super.new(name);
  endfunction


  virtual task body();
    repeat(1)begin
    req = alu_sequence_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
	end
  endtask
endclass

class add_sub extends uvm_sequence#(alu_sequence_item);
  
  `uvm_object_utils(add_sub)
   
  function new(string name = "add_sub");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.cmd inside {0, 1, 2, 3};req.ce == 1;req.mode == 1;req.inp_valid == 3;})
  endtask
endclass

class arith_both extends uvm_sequence#(alu_sequence_item);
  
  `uvm_object_utils(arith_both)
   
  function new(string name = "arith_both");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.cmd inside {8, 9, 10, 11, 12};req.ce == 1;req.mode == 1;req.inp_valid == 3;})
  endtask
endclass

class single_op_arith extends uvm_sequence#(alu_sequence_item);
  
  `uvm_object_utils(single_op_arith)
   
  function new(string name = "single_op_arith");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.cmd inside {4, 5, 6, 7};req.ce == 1;req.mode == 1;req.inp_valid == 3;})
  endtask
endclass

class cmd_out_of_order extends uvm_sequence#(alu_sequence_item);
  
  `uvm_object_utils(cmd_out_of_order)
   
  function new(string name = "cmd_out_of_order");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req, {req.ce == 1;req.mode -> req.cmd inside {13, 14, 15};!req.mode -> req.cmd inside {14, 15};})
  endtask
endclass

class check_ip_valid extends uvm_sequence#(alu_sequence_item);
  
  `uvm_object_utils(check_ip_valid)
   
  function new(string name = "check_ip_valid");
    super.new(name);
  endfunction
  
  virtual task body();
   `uvm_do_with(req, {req.ce == 1;req.mode -> req.cmd inside {0, 1, 2, 3, 4};!req.mode -> req.cmd inside {0, 1, 2, 3, 4, 5, 12};})
  endtask
endclass

class check_16 extends uvm_sequence#(alu_sequence_item);
  
  `uvm_object_utils(check_16)
   
  function new(string name = "check_16");
    super.new(name);
  endfunction
  
  virtual task body();
   `uvm_do_with(req, {req.ce == 1;req.mode -> req.cmd inside {0, 1, 2, 3, 4};!req.mode -> req.cmd inside {0, 1, 2, 3, 4, 5, 12};req.inp_valid inside {0,1, 2};})
  endtask
endclass

class sing_op_logic extends uvm_sequence#(alu_sequence_item);
  
  `uvm_object_utils(sing_op_logic)
   
  function new(string name = "sing_op_logic");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.cmd inside {6, 7, 8, 9, 10, 11};req.ce == 1;req.mode == 0;req.inp_valid == 3;})
  endtask
endclass

class both_logic_operation extends uvm_sequence#(alu_sequence_item);
  
  `uvm_object_utils(both_logic_operation)
   
  function new(string name = "both_logic_operation");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.cmd inside {0, 1, 2, 3, 4, 5};req.ce == 1;req.mode == 0;req.inp_valid == 3;})
  endtask
endclass

class logic_rotate extends uvm_sequence#(alu_sequence_item);
  
  `uvm_object_utils(logic_rotate)
   
  function new(string name = "logic_rotate");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.cmd inside {12, 13};req.ce == 1;req.mode == 0;req.inp_valid == 3;})
  endtask
endclass

class ce_check extends uvm_sequence#(alu_sequence_item);
  
  `uvm_object_utils(ce_check)
   
  function new(string name = "ce_check");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.cmd inside {0, 1, 2, 3};req.mode == 1;req.inp_valid == 3;})
  endtask
endclass

class alu_regression extends uvm_sequence#(alu_sequence_item);
  
  add_sub s1;
  arith_both s2;
  single_op_arith s3;
  cmd_out_of_order s4;
  check_ip_valid s5;
  check_16 s6;
  sing_op_logic s7;
  both_logic_operation s8;
  logic_rotate s9;
  ce_check s10;
  
  `uvm_object_utils(alu_regression)
   
  function new(string name = "alu_regression");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do(s1)
    `uvm_do(s2)
    `uvm_do(s3)
    `uvm_do(s4)
    `uvm_do(s5)
    `uvm_do(s6)
    `uvm_do(s7)
    `uvm_do(s8)
    `uvm_do(s9)
    `uvm_do(s10)
  endtask
endclass
