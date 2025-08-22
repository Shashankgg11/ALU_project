`include "define.sv"
class alu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alu_scoreboard)
    
    uvm_analysis_imp #(alu_sequence_item, alu_scoreboard) item_collected_export;
    
    int match = 0, mismatch = 0;
    alu_sequence_item monitor_queue[$];   
    
    function new (string name = "alu_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_collected_export = new("item_collected_export", this);
    endfunction
    
    virtual function void write(alu_sequence_item pack);
      $display("Scoreboard is received Packet");
      monitor_queue.push_back(pack);
      `uvm_info(get_type_name(),$sformatf("Scoreboard received from monitor:: Packet opa = %0d opb = %0d res = %0d queue size = %0d",pack.opa,pack.opb,pack.res,monitor_queue.size()),UVM_LOW)
    endfunction
    
  function bit both_op(alu_sequence_item sb_trans);
		if(sb_trans.mode)begin
			if(sb_trans.cmd == `ADD || sb_trans.cmd == `SUB || sb_trans.cmd == `ADD_CIN || sb_trans.cmd == `SUB_CIN || sb_trans.cmd == `CMP || sb_trans.cmd == `INC_MUL || sb_trans.cmd == `SHL1_A_MUL_B) return 1;
			else return 0;
		end
		else begin
		if(sb_trans.cmd == `AND || sb_trans.cmd == `NAND || sb_trans.cmd == `OR || sb_trans.cmd == `XOR || sb_trans.cmd == `NOR || sb_trans.cmd == `XNOR || sb_trans.cmd == `ROL_A_B || sb_trans.cmd == `ROR_A_B) return 1;
		else return 0;
		end
	endfunction
    
  function alu_sequence_item alu_ref_model(alu_sequence_item ref_trans);
    
        logic [`width+1:0] mul_res;
    	logic [`rot_bits-1:0] rot_val;
        ref_trans.res = {`width+1{1'bz}};
        ref_trans.err = 1'bz;
        ref_trans.g = 1'bz;
        ref_trans.e = 1'bz;
        ref_trans.l = 1'bz;
        ref_trans.oflow = 1'bz;
        ref_trans.cout = 1'bz;
        
        if (ref_trans.mode) begin  
        case (ref_trans.cmd)
            `ADD: begin
                ref_trans.res = ref_trans.opa + ref_trans.opb;
                ref_trans.cout = ref_trans.res[`width];
            end
            `SUB: begin
                ref_trans.res = ref_trans.opa - ref_trans.opb;
              	ref_trans.oflow = (ref_trans.opa < ref_trans.opb)?1:0;
            end
            `ADD_CIN: begin
                ref_trans.res = ref_trans.opa + ref_trans.opb + ref_trans.cin;
                ref_trans.cout = ref_trans.res[`width];
            end
            `SUB_CIN: begin
                ref_trans.res = ref_trans.opa - ref_trans.opb - ref_trans.cin;
              	ref_trans.oflow = (ref_trans.opa < ref_trans.opb)?1:0;
            end
            `INC_A: begin
                ref_trans.res = ref_trans.opa + 1;
                ref_trans.cout = ref_trans.res[`width];
            end
            `DEC_A: begin
                ref_trans.res = ref_trans.opa - 1;
                ref_trans.oflow = ref_trans.res[`width];
            end
            `INC_B: begin
                ref_trans.res = ref_trans.opb + 1;
                ref_trans.cout = ref_trans.res[`width];
            end
            `DEC_B: begin
                ref_trans.res = ref_trans.opb - 1;
                ref_trans.oflow = ref_trans.res[`width];
            end
            `CMP: begin
                ref_trans.l = ref_trans.opa < ref_trans.opb;
                ref_trans.e = ref_trans.opa == ref_trans.opb;
                ref_trans.g = ref_trans.opa > ref_trans.opb;
            end
            `INC_MUL: begin
                mul_res = (ref_trans.opa + 1) * (ref_trans.opb + 1);
                ref_trans.res = mul_res;
            end
            `SHL1_A_MUL_B: begin
                mul_res = (ref_trans.opa << 1) * ref_trans.opb;
                ref_trans.res = mul_res;
            end
            default: begin
                ref_trans.err = 1;
            end
        endcase
    end else begin 
        case (ref_trans.cmd)
            `AND:    ref_trans.res = {1'b0, ref_trans.opa & ref_trans.opb};
            `NAND:   ref_trans.res = {1'b0, ~(ref_trans.opa & ref_trans.opb)};
            `OR:     ref_trans.res = {1'b0, ref_trans.opa | ref_trans.opb};
            `NOR:    ref_trans.res = {1'b0, ~(ref_trans.opa | ref_trans.opb)};
            `XOR:    ref_trans.res = {1'b0, ref_trans.opa ^ ref_trans.opb};
            `XNOR:   ref_trans.res = {1'b0, ~(ref_trans.opa ^ ref_trans.opb)};
            `NOT_A:  ref_trans.res = {1'b0, ~ref_trans.opa};
            `NOT_B:  ref_trans.res = {1'b0, ~ref_trans.opb};
            `SHR1_A: ref_trans.res = {1'b0, ref_trans.opa >> 1};
            `SHL1_A: begin
                ref_trans.res = {ref_trans.opa, 1'b0};
                ref_trans.cout = ref_trans.res[`width];
            end
            `SHR1_B: ref_trans.res = {1'b0, ref_trans.opb >> 1};
            `SHL1_B: begin
                ref_trans.res = {ref_trans.opb, 1'b0};
                ref_trans.cout = ref_trans.res[`width];
            end
            `ROL_A_B: begin
                rot_val = ref_trans.opb[`rot_bits-1:0];
                ref_trans.res = {1'b0, (ref_trans.opa << rot_val) | (ref_trans.opa >> (`width - rot_val))};
                ref_trans.err = (ref_trans.opb >= `width);
            end
            `ROR_A_B: begin
                rot_val = ref_trans.opb[`rot_bits-1:0];
                ref_trans.res = {1'b0, (ref_trans.opa >> rot_val) | (ref_trans.opa << (`width - rot_val))};
                ref_trans.err = (ref_trans.opb >= `width);
            end
            default: begin
                ref_trans.err = 1;
            end
        endcase
    end
    return ref_trans;
endfunction
    
    virtual task run_phase(uvm_phase phase);
        alu_sequence_item actual_result;    
        alu_sequence_item expected_result;
      	alu_sequence_item latch_res;
        int count = 0;
      	latch_res = alu_sequence_item::type_id::create("latch_res");
        forever begin
            wait(monitor_queue.size() > 0);
            
            `uvm_info(get_type_name(), $sformatf("-------------------------------------"), UVM_LOW)
            expected_result = alu_sequence_item::type_id::create("expected_result");

            actual_result = monitor_queue.pop_front();
                     
          
          if(actual_result.ce)begin
				if(count != 0 && count <=16)begin
					if(actual_result.inp_valid == 3)begin
						count = 0;
                      	$display("inside 16 loop but inp_valuid 3 occured");
						expected_result = alu_ref_model(actual_result);
					end
                  else if(actual_result.inp_valid != 3 && count == 16)begin
						expected_result.res = {(`width+1){1'bZ}};
						expected_result.err = 1'b1;
						expected_result.oflow = 1'bZ;
						expected_result.cout = 1'bZ;
						expected_result.g = 1'bZ;
						expected_result.e = 1'bZ;
						expected_result.l = 1'bZ;
						count = 0;
                  		$display("inside 16 and count 16");
					end
					else begin
						expected_result.res = {(`width+1){1'bZ}};
						expected_result.err = 1'bZ;
						expected_result.oflow = 1'bZ;
						expected_result.cout = 1'bZ;
						expected_result.g = 1'bZ;
						expected_result.e = 1'bZ;
						expected_result.l = 1'bZ;
						count++;
                      	$display("inside 16 and inp valid again 1 or 2");
					end
				end
				else begin
					$display("outside 16 loop");
                  if((actual_result.inp_valid == 1 || actual_result.inp_valid == 2) && both_op(actual_result))begin
						expected_result.res = {(`width+1){1'bZ}};
						expected_result.err = 1'bZ;
						expected_result.oflow = 1'bZ;
						expected_result.cout = 1'bZ;
						expected_result.g = 1'bZ;
						expected_result.e = 1'bZ;
						expected_result.l = 1'bZ;
                      	$display("first inp_valid 1 or 2 occured");
						count ++;
					end
                    else if(actual_result.inp_valid == 0)begin
						expected_result.res = {(`width+1){1'bZ}};
						expected_result.err = 1'bZ;
						expected_result.oflow = 1'bZ;
						expected_result.cout = 1'bZ;
						expected_result.g = 1'bZ;
						expected_result.e = 1'bZ;
						expected_result.l = 1'bZ;
                      	count = 0;
                      	$display("outside 16 and inp 0");
					end
					else begin
					  	expected_result = alu_ref_model(actual_result);
                      $display("outside 16 and inp 0 or 3 or noth both_op");
                      	count = 0;
					end
				end
          	$display("count = %0d", count);
            latch_res.copy(expected_result);
			end
			else begin
              	expected_result.copy(latch_res);
              	$display("count = %0d", count);
			end
            
            if ({actual_result.res, actual_result.err, actual_result.oflow, actual_result.cout, 
                 actual_result.g, actual_result.e, actual_result.l} === 
                {expected_result.res, expected_result.err, expected_result.oflow, expected_result.cout, 
                 expected_result.g, expected_result.e, expected_result.l}) begin
                
                match++;
                `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
                `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
                `uvm_info(get_type_name(), $sformatf("Expected: res=%0d err=%0d oflow=%0d cout=%0d g=%0d e=%0d l=%0d",
                    expected_result.res, expected_result.err, expected_result.oflow, expected_result.cout, 
                    expected_result.g, expected_result.e, expected_result.l), UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("Actual  : res=%0d err=%0d oflow=%0d cout=%0d g=%0d e=%0d l=%0d",
                    actual_result.res, actual_result.err, actual_result.oflow, actual_result.cout, 
                    actual_result.g, actual_result.e, actual_result.l), UVM_LOW)
              `uvm_info(get_type_name(), $sformatf("number of matches = %0d",match), UVM_LOW)
                    
            end else begin
                mismatch++;
                `uvm_error(get_type_name(), "----           TEST FAIL           ----")
                `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
                `uvm_info(get_type_name(), $sformatf("Expected: res=%0d err=%0d oflow=%0d cout=%0d g=%0d e=%0d l=%0d",
                    expected_result.res, expected_result.err, expected_result.oflow, expected_result.cout, 
                    expected_result.g, expected_result.e, expected_result.l), UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("Actual  : res=%0d err=%0d oflow=%0d cout=%0d g=%0d e=%0d l=%0d",
                    actual_result.res, actual_result.err, actual_result.oflow, actual_result.cout, 
                    actual_result.g, actual_result.e, actual_result.l), UVM_LOW)
              `uvm_info(get_type_name(), $sformatf("number of mismatches = %0d",mismatch), UVM_LOW)
            end
            
            `uvm_info(get_type_name(), "------------------------------------", UVM_LOW)
        end
    endtask
endclass
