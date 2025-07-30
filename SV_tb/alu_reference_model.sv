`include "define.sv"
class alu_reference_model;
	alu_transaction ref_trans;
	mailbox #(alu_transaction) mbx_rs;
	mailbox #(alu_transaction) mbx_dr;
	virtual alu_if.REF_SB vif;
	bit [`rot_bits-1:0] rot_val;
    function new(mailbox #(alu_transaction) mbx_dr, mailbox #(alu_transaction) mbx_rs, virtual alu_if.REF_SB vif);
		this.mbx_dr=mbx_dr;
		this.mbx_rs=mbx_rs;
		this.vif=vif;
	endfunction
  function both_op(alu_transaction ref_trans);
		if(ref_trans.cmd == `ADD || ref_trans.cmd == `SUB || ref_trans.cmd == `ADD_CIN || ref_trans.cmd == `SUB_CIN || ref_trans.cmd == `CMP || ref_trans.cmd == `INC_MUL || ref_trans.cmd == `SHL1_A_MUL_B || ref_trans.cmd == `ADD_SIGN || ref_trans.cmd == `SUB_SIGN || ref_trans.cmd == `AND || ref_trans.cmd == `NAND || ref_trans.cmd == `OR || ref_trans.cmd == `XOR || ref_trans.cmd == `NOR || ref_trans.cmd == `XNOR || ref_trans.cmd == `ROL_A_B) return 1;
        else return 0;
    endfunction
  function void op_store(alu_transaction ref_trans, ref logic [`width+1:0]temp_res, ref logic temp_err, ref logic temp_g, ref logic temp_e, ref logic temp_l, ref logic temp_oflow, ref logic temp_cout);
		temp_res = ref_trans.res;
		temp_err = ref_trans.err;
		temp_g = ref_trans.g;
		temp_e = ref_trans.e;
		temp_l = ref_trans.l;
		temp_oflow = ref_trans.oflow;
		temp_cout = ref_trans.cout;
      //$display("res = %d \n",temp_res);
	endfunction
	
		function alu_transaction alu_result(alu_transaction ref_trans);
		logic [`width+1:0] mul_res;
		logic [`rot_bits-1:0] rot_val;
		ref_trans.res = {`width+1{1'bZ}};
        ref_trans.err = 1'bz;
        ref_trans.g = 1'bZ;
        ref_trans.e = 1'bZ;
        ref_trans.l = 1'bZ;
        ref_trans.oflow = 1'bZ;
        ref_trans.cout = 1'bZ;
			if (ref_trans.mode) begin  // Arithmetic mode
				case (ref_trans.cmd)
                    `ADD: begin
						ref_trans.res = ref_trans.opa + ref_trans.opb;
                        ref_trans.cout = ref_trans.res[`width];
                    end
                    `SUB: begin
                        ref_trans.res = ref_trans.opa - ref_trans.opb;
                        ref_trans.oflow = (ref_trans.opa[`width-1] != ref_trans.opb[`width-1]) && (ref_trans.res[`width-1] != ref_trans.opa[`width-1]);
                    end
                    `ADD_CIN: begin
						ref_trans.res = ref_trans.opa + ref_trans.opb + ref_trans.cin;
                        ref_trans.cout = ref_trans.res[`width];
					end
                    `SUB_CIN: begin
						ref_trans.res = ref_trans.opa - ref_trans.opb - ref_trans.cin;
                        ref_trans.oflow = (ref_trans.opa[`width-1] != ref_trans.opb[`width-1]) && (ref_trans.res[`width-1] != ref_trans.opa[`width-1]);
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
					`ADD_SIGN: begin
						ref_trans.res = $signed(ref_trans.opa) + $signed(ref_trans.opb);
						ref_trans.oflow = ((ref_trans.opa[`width-1] == ref_trans.opb[`width-1]) && (ref_trans.res[`width-1] != ref_trans.opa[`width-1])) ? 1'b1 : 1'b0;                                                ref_trans.l = ($signed(ref_trans.opa) < $signed(ref_trans.opb));
                        ref_trans.l = ($signed(ref_trans.opa) < $signed(ref_trans.opb));
						ref_trans.e = ($signed(ref_trans.opa) == $signed(ref_trans.opb));
						ref_trans.g = ($signed(ref_trans.opa) > $signed(ref_trans.opb));
					end
					`SUB_SIGN: begin
						ref_trans.res = $signed(ref_trans.opa) - $signed(ref_trans.opb);
						ref_trans.oflow = ((ref_trans.opa[`width-1] != ref_trans.opb[`width-1]) && (ref_trans.res[`width-1] != ref_trans.opa[`width-1])) ? 1'b1 : 1'b0;
						ref_trans.l = ($signed(ref_trans.opa) < $signed(ref_trans.opb));
						ref_trans.e = ($signed(ref_trans.opa) == $signed(ref_trans.opb));
                        ref_trans.g = ($signed(ref_trans.opa) > $signed(ref_trans.opb));
					end
					default: begin
						ref_trans.err = 1;
					end
				endcase
			end
			else begin  // Logic mode
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
					4'b1101: begin // ROR
						rot_val = ref_trans.opb[`rot_bits-1:0];
						ref_trans.res = {1'b0, (ref_trans.opa >> rot_val) | (ref_trans.opa << (`width - rot_val))};
						ref_trans.err = (ref_trans.opb >= `width);
					end
					default: begin
						ref_trans.err = 1;
					end
				endcase
			end
		endfunction


  //Task which mimics the functionality of the RAM
task start();
    logic [`width+1:0] temp_res = {(`width+1){1'bz}};
    logic temp_err = 1'bz;
    logic temp_g = 1'bz;
    logic temp_e = 1'bz;
    logic temp_l = 1'bz;
    logic temp_oflow = 1'bz;
    logic temp_cout = 1'bz;
    int count = 0;
  repeat(5) @(vif.ref_cb);
    for(int i=0;i<`no_of_trans;i++)begin
                ref_trans=new();
                mbx_dr.get(ref_trans);
                repeat(1) @(vif.ref_cb);
                if(vif.ref_cb.rst)begin
                        ref_trans.res = 0;
                        ref_trans.err = 0;
                        ref_trans.g = 0;
                        ref_trans.e = 0;
                        ref_trans.l = 0;
                        ref_trans.oflow = 0;
                        ref_trans.cout = 0;
                        count = 0;
                        mbx_rs.put(ref_trans);
						op_store(ref_trans, temp_res, temp_err, temp_g, temp_e, temp_l, temp_oflow, temp_cout);
                        $display("Reference op res=%d, err=%d, oflow=%d, cout=%d, g=%d, l=%d, e=%d at time %t",ref_trans.res, ref_trans.err, ref_trans.oflow,ref_trans.cout, ref_trans.g, ref_trans.l, ref_trans.e, $time);
                        repeat(1) @(vif.ref_cb);
                end
				else if(!vif.ref_cb.rst && !ref_trans.ce) begin
					ref_trans.res = temp_res;
                    ref_trans.err = temp_err;
                    ref_trans.g = temp_g;
                    ref_trans.e = temp_e;
                    ref_trans.l = temp_l;
                    ref_trans.oflow = temp_oflow;
                    ref_trans.cout = temp_cout;
                    mbx_rs.put(ref_trans);
					op_store(ref_trans, temp_res, temp_err, temp_g, temp_e, temp_l, temp_oflow, temp_cout);
                    $display("Reference op res=%d, err=%d, oflow=%d, cout=%d, g=%d, l=%d, e=%d at time %t",ref_trans.res, ref_trans.err, ref_trans.oflow,ref_trans.cout, ref_trans.g, ref_trans.l, ref_trans.e, $time);
                    repeat(1) @(vif.ref_cb);
				end
				else begin
                    if(both_op(ref_trans))begin
                        if(ref_trans.inp_valid == 3) begin
                            void'(alu_result(ref_trans));
                            count = 0;
                            mbx_rs.put(ref_trans);
							op_store(ref_trans, temp_res, temp_err, temp_g, temp_e, temp_l, temp_oflow, temp_cout);
                            $display("Reference op res=%d, err=%d, oflow=%d, cout=%d, g=%d, l=%d, e=%d at time %t",ref_trans.res, ref_trans.err, ref_trans.oflow,ref_trans.cout, ref_trans.g, ref_trans.l, ref_trans.e, $time);
                            repeat(1) @(vif.ref_cb);
                        end
						else if(ref_trans.inp_valid == 0)begin
							ref_trans.res = {`width+1{1'bZ}};
                            ref_trans.err = 1'bZ;
                            ref_trans.g = 1'bZ;
                            ref_trans.e = 1'bZ;
                            ref_trans.l = 1'bZ;
                            ref_trans.oflow = 1'bZ;
                            ref_trans.cout = 1'bZ;
                            mbx_rs.put(ref_trans);
							op_store(ref_trans, temp_res, temp_err, temp_g, temp_e, temp_l, temp_oflow, temp_cout);
                            $display("Reference op res=%d, err=%d, oflow=%d, cout=%d, g=%d, l=%d, e=%d at time %t",ref_trans.res, ref_trans.err, ref_trans.oflow,ref_trans.cout, ref_trans.g, ref_trans.l, ref_trans.e, $time);
                            repeat(1) @(vif.ref_cb);
						end
                        else begin
                            ref_trans.res = {`width+1{1'bZ}};
                            ref_trans.err = 1'bz;
                            ref_trans.g = 1'bZ;
                            ref_trans.e = 1'bZ;
                            ref_trans.l = 1'bZ;
                            ref_trans.oflow = 1'bZ;
                            ref_trans.cout = 1'bZ;
                            mbx_rs.put(ref_trans);
							op_store(ref_trans, temp_res, temp_err, temp_g, temp_e, temp_l, temp_oflow, temp_cout);
                            $display("Reference op res=%d, err=%d, oflow=%d, cout=%d, g=%d, l=%d, e=%d at time %t",ref_trans.res, ref_trans.err, ref_trans.oflow,ref_trans.cout, ref_trans.g, ref_trans.l, ref_trans.e, $time);
                            repeat(1) @(vif.ref_cb);
                            for(int i = 0;i < 16;i++)begin
                                mbx_dr.get(ref_trans);
                                repeat(1) @(vif.ref_cb);
								if(!ref_trans.ce)begin
									ref_trans.res = temp_res;
									ref_trans.err = temp_err;
									ref_trans.g = temp_g;
									ref_trans.e = temp_e;
									ref_trans.l = temp_l;
									ref_trans.oflow = temp_oflow;
									ref_trans.cout = temp_cout;
									mbx_rs.put(ref_trans);				
									mbx_rs.put(ref_trans);
									op_store(ref_trans, temp_res, temp_err, temp_g, temp_e, temp_l, temp_oflow, temp_cout);
									$display("Reference op res=%d, err=%d, oflow=%d, cout=%d, g=%d, l=%d, e=%d at time %t",ref_trans.res, ref_trans.err, ref_trans.oflow,ref_trans.cout, ref_trans.g, ref_trans.l, ref_trans.e, $time);
									repeat(1) @(vif.ref_cb);
								end
                                else if(ref_trans.ce && ref_trans.inp_valid == 3) begin
									count = 0;
									void'(alu_result(ref_trans));
									mbx_rs.put(ref_trans);
									op_store(ref_trans, temp_res, temp_err, temp_g, temp_e, temp_l, temp_oflow, temp_cout);
									$display("Reference op res=%d, err=%d, oflow=%d, cout=%d, g=%d, l=%d, e=%d at time %t",ref_trans.res, ref_trans.err, ref_trans.oflow,ref_trans.cout, ref_trans.g, ref_trans.l, ref_trans.e, $time);
									repeat(1) @(vif.ref_cb);
									break;
                                end
                                else begin
                                    count += 1;
									ref_trans.res = {`width+1{1'bZ}};
                                    ref_trans.err = 1'bZ;
                                    ref_trans.g = 1'bZ;
                                    ref_trans.e = 1'bZ;
                                    ref_trans.l = 1'bZ;
                                    ref_trans.oflow = 1'bZ;
                                    ref_trans.cout = 1'bZ;
                                    mbx_rs.put(ref_trans);
									op_store(ref_trans, temp_res, temp_err, temp_g, temp_e, temp_l, temp_oflow, temp_cout);
                                    $display("Reference op res=%d, err=%d, oflow=%d, cout=%d, g=%d, l=%d, e=%d at time %t",ref_trans.res, ref_trans.err, ref_trans.oflow,ref_trans.cout, ref_trans.g, ref_trans.l, ref_trans.e, $time);
                                    repeat(1) @(vif.ref_cb);
                                    if(count >=16) begin
										count = 0;
                                        break;
                                    end
								end		
                            end
                        end
                    end
                    else begin
						void'(alu_result(ref_trans));
                        mbx_rs.put(ref_trans);
						op_store(ref_trans, temp_res, temp_err, temp_g, temp_e, temp_l, temp_oflow, temp_cout);
                        $display("Reference op res=%d, err=%d, oflow=%d, cout=%d, g=%d, l=%d, e=%d at time %t",ref_trans.res, ref_trans.err, ref_trans.oflow,ref_trans.cout, ref_trans.g, ref_trans.l, ref_trans.e, $time);
                        repeat(1) @(vif.ref_cb);
                    end
				end
			end
		endtask
	endclass
