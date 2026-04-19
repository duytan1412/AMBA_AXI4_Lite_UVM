`ifndef AXI4_LITE_ENV_SV
`define AXI4_LITE_ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi4_lite_agent.sv"
`include "axi4_lite_scoreboard.sv"

class axi4_lite_env extends uvm_env;
    `uvm_component_utils(axi4_lite_env)

    axi4_lite_agent      agent;
    axi4_lite_scoreboard scoreboard;

    function new(string name = "axi4_lite_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent      = axi4_lite_agent::type_id::create("agent", this);
        scoreboard = axi4_lite_scoreboard::type_id::create("scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        agent.monitor.ap.connect(scoreboard.ap_imp);
    endfunction
endclass

`endif

//---------------------------------------------------------
// Test Library
//---------------------------------------------------------

`ifndef AXI4_LITE_TEST_LIB_SV
`define AXI4_LITE_TEST_LIB_SV

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    axi4_lite_env env;

    function new(string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi4_lite_env::type_id::create("env", this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print();
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100ns;
        `uvm_info("TEST", "Starting AXI4-Lite UVM Base Test...", UVM_LOW)
        phase.drop_objection(this);
    endtask
endclass

// Random Write/Read Sequence
class axi_rand_seq extends uvm_sequence#(axi4_lite_transaction);
    `uvm_object_utils(axi_rand_seq)

    function new(string name = "axi_rand_seq");
        super.new(name);
    endfunction

    task body();
        repeat(10) begin
            req = axi4_lite_transaction::type_id::create("req");
            start_item(req);
            if (!req.randomize()) `uvm_error("SEQ", "Randomization failed")
            finish_item(req);
        end
    endtask
endclass

`endif
