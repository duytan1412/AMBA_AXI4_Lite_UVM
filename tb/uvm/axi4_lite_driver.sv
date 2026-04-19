`ifndef AXI4_LITE_DRIVER_SV
`define AXI4_LITE_DRIVER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

typedef uvm_sequencer#(axi4_lite_transaction) axi4_lite_sequencer;

class axi4_lite_driver extends uvm_driver#(axi4_lite_transaction);
    `uvm_component_utils(axi4_lite_driver)

    virtual axi4_lite_if vif;

    function new(string name = "axi4_lite_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi4_lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRIVER", "Could not get virtual interface!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        // Initialize signals
        vif.awvalid <= 0;
        vif.wvalid  <= 0;
        vif.bready  <= 0;
        vif.arvalid <= 0;
        vif.rready  <= 0;

        wait(vif.aresetn);
        forever begin
            seq_item_port.get_next_item(req);
            if (req.operation == axi4_lite_transaction::WRITE)
                drive_write(req);
            else
                drive_read(req);
            seq_item_port.item_done();
        end
    endtask

    virtual task drive_write(axi4_lite_transaction tr);
        @(posedge vif.aclk);
        vif.awaddr  <= tr.addr;
        vif.awprot  <= tr.prot;
        vif.awvalid <= 1;
        vif.wdata   <= tr.data;
        vif.wstrb   <= tr.strb;
        vif.wvalid  <= 1;
        vif.bready  <= 1;

        // Wait for address and data handshakes
        fork
            wait(vif.awready);
            wait(vif.wready);
        join
        
        @(posedge vif.aclk);
        vif.awvalid <= 0;
        vif.wvalid  <= 0;

        // Wait for write response
        while (!vif.bvalid) @(posedge vif.aclk);
        tr.resp = vif.bresp;
        @(posedge vif.aclk);
        vif.bready  <= 0;
    endtask

    virtual task drive_read(axi4_lite_transaction tr);
        @(posedge vif.aclk);
        vif.araddr  <= tr.addr;
        vif.arprot  <= tr.prot;
        vif.arvalid <= 1;
        vif.rready  <= 1;

        wait(vif.arready);
        @(posedge vif.aclk);
        vif.arvalid <= 0;

        // Wait for read data
        while (!vif.rvalid) @(posedge vif.aclk);
        tr.data = vif.rdata;
        tr.resp = vif.rresp;
        @(posedge vif.aclk);
        vif.rready  <= 0;
    endtask

endclass

`endif
