`ifndef AXI4_LITE_SCOREBOARD_SV
`define AXI4_LITE_SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class axi4_lite_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(axi4_lite_scoreboard)

    uvm_analysis_imp#(axi4_lite_transaction, axi4_lite_scoreboard) ap_imp;
    logic [31:0] ref_mem [logic [31:0]];

    int matches = 0;
    int mismatches = 0;

    function new(string name = "axi4_lite_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp = new("ap_imp", this);
    endfunction

    virtual function void write(axi4_lite_transaction tr);
        if (tr.operation == axi4_lite_transaction::WRITE) begin
            ref_mem[tr.addr] = tr.data;
            `uvm_info("AXI_SCB", $sformatf("WRITE: Addr=0x%0h Data=0x%0h", tr.addr, tr.data), UVM_MEDIUM)
        end else begin
            logic [31:0] exp_data = ref_mem.exists(tr.addr) ? ref_mem[tr.addr] : 32'h0;
            if (tr.data === exp_data) begin
                matches++;
                `uvm_info("AXI_SCB", $sformatf("MATCH! Addr=0x%0h Data=0x%0h", tr.addr, tr.data), UVM_LOW)
            end else begin
                mismatches++;
                `uvm_error("AXI_SCB", $sformatf("MISMATCH! Addr=0x%0h Got=0x%0h Exp=0x%0h", tr.addr, tr.data, exp_data))
            end
        end
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info("AXI_SCB", "========================================", UVM_NONE)
        `uvm_info("AXI_SCB", $sformatf("Report: Matches=%0d, Mismatches=%0d", matches, mismatches), UVM_NONE)
        `uvm_info("AXI_SCB", "========================================", UVM_NONE)
    endfunction
endclass

`endif
