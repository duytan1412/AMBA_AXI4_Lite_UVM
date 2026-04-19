`timescale 1ns / 1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "../if/axi4_lite_if.sv"
`include "../../rtl/axi4_lite_slave.sv"
`include "axi4_lite_env.sv"
`include "axi4_lite_test_lib.sv"

module tb_top;

    // Clock and Reset Generation
    logic clk;
    logic rst_n;

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz
    end

    initial begin
        rst_n = 0;
        #20 rst_n = 1;
    end

    // Interface Instance
    axi4_lite_if #(
        .DATA_WIDTH(32),
        .ADDR_WIDTH(5)
    ) intf (
        .aclk(clk),
        .aresetn(rst_n)
    );

    // DUT Instance
    axi4_lite_slave #(
        .DATA_WIDTH(32),
        .ADDR_WIDTH(5)
    ) dut (
        .aclk(intf.aclk),
        .aresetn(intf.aresetn),
        .s_axi_awaddr(intf.awaddr),
        .s_axi_awprot(intf.awprot),
        .s_axi_awvalid(intf.awvalid),
        .s_axi_awready(intf.awready),
        .s_axi_wdata(intf.wdata),
        .s_axi_wstrb(intf.wstrb),
        .s_axi_wvalid(intf.wvalid),
        .s_axi_wready(intf.wready),
        .s_axi_bresp(intf.bresp),
        .s_axi_bvalid(intf.bvalid),
        .s_axi_bready(intf.bready),
        .s_axi_araddr(intf.araddr),
        .s_axi_arprot(intf.arprot),
        .s_axi_arvalid(intf.arvalid),
        .s_axi_arready(intf.arready),
        .s_axi_rdata(intf.rdata),
        .s_axi_rresp(intf.rresp),
        .s_axi_rvalid(intf.rvalid),
        .s_axi_rready(intf.rready)
    );

    initial begin
        // Set Interface in Config DB
        uvm_config_db#(virtual axi4_lite_if)::set(null, "*", "vif", intf);
        
        // Start Test
        run_test("base_test");
    end

    // Monitoring
    initial begin
        $dumpfile("axi4_lite_uvm.vcd");
        $dumpvars(0, tb_top);
    end

endmodule
