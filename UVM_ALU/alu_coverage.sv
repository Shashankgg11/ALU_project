`uvm_analysis_imp_decl(_mon_cg)
`uvm_analysis_imp_decl(_drv_cg)

class alu_coverage extends uvm_component;

  `uvm_component_utils(alu_coverage)
  

  uvm_analysis_imp_mon_cg #(alu_sequence_item, alu_coverage) aport_mon1;
  uvm_analysis_imp_drv_cg #(alu_sequence_item, alu_coverage) aport_drv1;

alu_sequence_item txn_mon1, txn_drv1;
real mon1_cov,drv1_cov;

covergroup driver_cov;
  
  MODE_CP: coverpoint txn_drv1.mode;
  INP_VALID_CP : coverpoint txn_drv1.inp_valid;
 
  CMD_CP : coverpoint txn_drv1.cmd { bins valid_cmd[] = {[0:13]};
                                 ignore_bins invalid_cmd[] = {14, 15}; }
  OPA_CP : coverpoint txn_drv1.opa { 
      bins opa[] = {[0:`MAX]};
    }
    OPB_CP : coverpoint txn_drv1.opb { 
      bins opb[] = {[0:`MAX]};
    }
    CIN_CP : coverpoint txn_drv1.cin;
    CMD_X_IP_V: cross CMD_CP, INP_VALID_CP;
    MODE_X_INP_V: cross MODE_CP, INP_VALID_CP;
    MODE_X_CMD: cross MODE_CP, CMD_CP;
  
endgroup

covergroup monitor_cov;
  RESULT_CHECK:coverpoint txn_mon1.res { bins result[]={[0:`MAX]};
                                                            option.auto_bin_max = 8;}
        CARR_OUT:coverpoint txn_mon1.cout{ bins cout_active = {1};
                                            bins cout_inactive = {0};
                                          }
        OVERFLOW:coverpoint txn_mon1.oflow { bins oflow_active = {1};
                                              bins oflow_inactive = {0};
                                            }
        ERROR:coverpoint txn_mon1.err { bins error_active = {1};
                                       }
        GREATER:coverpoint txn_mon1.g { bins greater_active = {1};
                                       }
        EQUAL:coverpoint txn_mon1.e { bins equal_active = {1};
                                     }
        LESSER:coverpoint txn_mon1.l { bins lesser_active = {1};
                                    }
 
endgroup

function new(string name = "", uvm_component parent);
  super.new(name, parent);
  monitor_cov = new;
  driver_cov = new;
  aport_drv1=new("aport_drv1", this);
 
  aport_mon1 = new("aport_mon1", this);
  
endfunction
  
  function void write_drv_cg(alu_sequence_item t);
  txn_drv1 = t;
  driver_cov.sample();
endfunction


  function void write_mon_cg(alu_sequence_item t);
  txn_mon1 = t;
  monitor_cov.sample();
     txn_drv1 = t;
  driver_cov.sample();
endfunction
  

function void extract_phase(uvm_phase phase);
  super.extract_phase(phase);
  drv1_cov = driver_cov.get_coverage();
  mon1_cov = monitor_cov.get_coverage();
endfunction

function void report_phase(uvm_phase phase);
  super.report_phase(phase);
  `uvm_info(get_type_name, $sformatf("[DRIVER] Coverage ------> %0.2f%%,", drv1_cov), UVM_MEDIUM);
  `uvm_info(get_type_name, $sformatf("[MONITOR] Coverage ------> %0.2f%%", mon1_cov), UVM_MEDIUM);
  endfunction

endclass
