`ifndef AXI4_LITE_MONITOR_SV
`define AXI4_LITE_MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class axi4_lite_monitor extends uvm_monitor;
    `uvm_component_utils(axi4_lite_monitor)

    virtual axi4_lite_if vif;
    uvm_analysis_port#(axi4_lite_transaction) ap;

    function new(string name = "axi4_lite_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual axi4_lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("MONITOR", "Could not get virtual interface!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        fork
            monitor_write();
            monitor_read();
        join
    endtask

    task monitor_write();
        axi4_lite_transaction tr;
        forever begin
            @(posedge vif.aclk);
            // Detect Write Handshake
            if (vif.awvalid && vif.awready && vif.wvalid && vif.wready) begin
                tr = axi4_lite_transaction::type_id::create("tr");
                tr.operation = axi4_lite_transaction::WRITE;
                tr.addr      = vif.awaddr;
                tr.data      = vif.wdata;
                tr.strb      = vif.wstrb;
                tr.prot      = vif.awprot;
                
                // Wait for B-channel
                while (!(vif.bvalid && vif.bready)) @(posedge vif.aclk);
                tr.resp = vif.bresp;
                ap.write(tr);
            end
        end
    endtask

    task monitor_read();
        axi4_lite_transaction tr;
        forever begin
            @(posedge vif.aclk);
            // Detect Read Address Handshake
            if (vif.arvalid && vif.arready) begin
                tr = axi4_lite_transaction::type_id::create("tr");
                tr.operation = axi4_lite_transaction::READ;
                tr.addr      = vif.araddr;
                tr.prot      = vif.arprot;
                
                // Wait for Read Data Handshake
                while (!(vif.rvalid && vif.rready)) @(posedge vif.aclk);
                tr.data = vif.rdata;
                tr.resp = vif.rresp;
                ap.write(tr);
            end
        end
    endtask

endclass

`endif
