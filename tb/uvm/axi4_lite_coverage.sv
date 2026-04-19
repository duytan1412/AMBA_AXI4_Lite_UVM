`ifndef AXI4_LITE_COVERAGE_SV
`define AXI4_LITE_COVERAGE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class axi4_lite_coverage extends uvm_subscriber #(axi4_lite_transaction);
    `uvm_component_utils(axi4_lite_coverage)

    axi4_lite_transaction tr;

    //---------------------------------------------------------
    // COVERGROUP DEFINITION
    //---------------------------------------------------------
    covergroup cg_axi4_lite;
        option.per_instance = 1;
        option.name = "cg_axi4_lite";

        // Address Coverage
        cp_addr: coverpoint tr.addr {
            bins reg0 = {32'h0};
            bins reg1 = {32'h4};
            bins reg2 = {32'h8};
            bins reg3 = {32'hC};
            bins others = {[32'h0000_0010 : 32'hFFFF_FFFF]};
        }

        // Operation type
        cp_op: coverpoint tr.operation;

        // Response Coverage (Critical for professional upgrade)
        cp_resp: coverpoint tr.resp {
            bins okay  = {2'b00};
            bins exokay = {2'b01};
            bins slverr = {2'b10};
            bins decerr = {2'b11};
        }

        // Byte Strobes
        cp_strb: coverpoint tr.strb {
            bins full_word = {4'hF};
            bins partial   = {[4'h1 : 4'hE]};
        }

        // Cross Coverage
        cross_op_resp: cross cp_op, cp_resp;
        cross_addr_resp: cross cp_addr, cp_resp;

    endgroup

    function new(string name = "axi4_lite_coverage", uvm_component parent);
        super.new(name, parent);
        cg_axi4_lite = new();
    endfunction

    virtual function void write(axi4_lite_transaction t);
        this.tr = t;
        cg_axi4_lite.sample();
    endfunction

endclass

`endif
