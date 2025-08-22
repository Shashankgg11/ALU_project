class alu_environment extends uvm_env;
  alu_agent alu_active_agent;
  alu_agent alu_passive_agent;
  alu_scoreboard alu_scoreboard_1;
  alu_coverage alu_coverage_1;
  
  `uvm_component_utils(alu_environment)
  
  function new(string name = "alu_environment", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    alu_active_agent = alu_agent::type_id::create("alu_active_agent", this);
    alu_passive_agent = alu_agent::type_id::create("alu_passive_agent", this);
    alu_scoreboard_1 = alu_scoreboard::type_id::create("scoreboard_1", this);
    alu_coverage_1 = alu_coverage::type_id::create("coverage_1", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    alu_passive_agent.alu_monitor_1.item_collected_port.connect(alu_scoreboard_1.item_collected_export);
    alu_passive_agent.alu_monitor_1.item_collected_port.connect(alu_coverage_1.aport_drv1);
    alu_active_agent.alu_monitor_1.item_collected_port.connect(alu_coverage_1.aport_mon1); 
  endfunction

endclass
