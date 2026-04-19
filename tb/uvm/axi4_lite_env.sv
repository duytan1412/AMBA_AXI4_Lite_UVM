`ifndef AXI4_LITE_ENV_SV
`define AXI4_LITE_ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi4_lite_agent.sv"
`include "axi4_lite_scoreboard.sv"
`include "axi4_lite_coverage.sv"

//---------------------------------------------------------
// PROFESSIONAL AXI4-LITE UVM ENVIRONMENT
//---------------------------------------------------------
class axi4_lite_env extends uvm_env;
    `uvm_component_utils(axi4_lite_env)

    axi4_lite_agent      agent;
    axi4_lite_scoreboard scoreboard;
    axi4_lite_coverage   coverage;

    function new(string name = "axi4_lite_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent      = axi4_lite_agent::type_id::create("agent", this);
        scoreboard = axi4_lite_scoreboard::type_id::create("scoreboard", this);
        coverage   = axi4_lite_coverage::type_id::create("coverage", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        // Connect Monitor to Scoreboard
        agent.monitor.ap.connect(scoreboard.ap_imp);
        
        // Connect Monitor to Coverage Subscriber
        agent.monitor.ap.connect(coverage.analysis_export);
    endfunction

endclass

`endif
