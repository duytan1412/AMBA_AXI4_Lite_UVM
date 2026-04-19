`ifndef AXI4_LITE_AGENT_SV
`define AXI4_LITE_AGENT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi4_lite_transaction.sv"
`include "axi4_lite_driver.sv"
`include "axi4_lite_monitor.sv"

class axi4_lite_agent extends uvm_agent;
    `uvm_component_utils(axi4_lite_agent)

    axi4_lite_driver    driver;
    axi4_lite_monitor   monitor;
    axi4_lite_sequencer sequencer;

    function new(string name = "axi4_lite_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = axi4_lite_monitor::type_id::create("monitor", this);
        if (get_is_active() == UVM_ACTIVE) begin
            driver    = axi4_lite_driver::type_id::create("driver", this);
            sequencer = axi4_lite_sequencer::type_id::create("sequencer", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        if (get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
endclass

`endif
