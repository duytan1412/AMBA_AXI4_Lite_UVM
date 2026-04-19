`ifndef AXI4_LITE_TEST_LIB_SV
`define AXI4_LITE_TEST_LIB_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

//---------------------------------------------------------
// REUSABLE SEQUENCES
//---------------------------------------------------------

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

// Error Injection Sequence: Accessing Invalid Address
class axi_error_seq extends uvm_sequence#(axi4_lite_transaction);
    `uvm_object_utils(axi_error_seq)

    function new(string name = "axi_error_seq");
        super.new(name);
    endfunction

    task body();
        // Send transaction to an out-of-range address (e.g., 0x100)
        req = axi4_lite_transaction::type_id::create("req");
        start_item(req);
        if (!req.randomize() with { addr == 32'h0000_0100; }) 
            `uvm_error("SEQ", "Randomization failed")
        finish_item(req);
        
        `uvm_info("SEQ", "Sent ERROR injection transaction to addr 0x100", UVM_LOW)
    endtask
endclass

//---------------------------------------------------------
// TEST LIBRARY
//---------------------------------------------------------

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
        axi_rand_seq seq;
        phase.raise_objection(this);
        seq = axi_rand_seq::type_id::create("seq");
        `uvm_info("TEST", "Starting AXI4-Lite Random Test...", UVM_LOW)
        seq.start(env.agent.sequencer);
        #100ns;
        phase.drop_objection(this);
    endtask
endclass

// Dedicated Error Response Test
class axi_error_test extends base_test;
    `uvm_component_utils(axi_error_test)

    function new(string name = "axi_error_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_error_seq err_seq;
        phase.raise_objection(this);
        err_seq = axi_error_seq::type_id::create("err_seq");
        `uvm_info("TEST", "Starting AXI4-Lite Error Response Test...", UVM_LOW)
        err_seq.start(env.agent.sequencer);
        #100ns;
        phase.drop_objection(this);
    endtask
endclass

`endif
