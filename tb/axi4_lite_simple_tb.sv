`timescale 1ns / 1ps

module axi4_lite_simple_tb();

    reg clk;
    reg aresetn;

    // AXI signals
    wire [4:0]  awaddr;
    wire        awvalid;
    wire        awready;
    wire [31:0] wdata;
    wire [3:0]  wstrb;
    wire        wvalid;
    wire        wready;
    wire [1:0]  bresp;
    wire        bvalid;
    reg         bready;

    // Read Channels
    wire [4:0]  araddr;
    wire        arvalid;
    wire        arready;
    wire [31:0] rdata;
    wire [1:0]  rresp;
    wire        rvalid;
    wire        rready;

    // Master-side registers for stimulus generation
    reg [4:0]  r_awaddr;
    reg        r_awvalid;
    reg [31:0] r_wdata;
    reg        r_wvalid;
    reg [4:0]  r_araddr;
    reg        r_arvalid;
    reg        r_rready;

    assign awaddr  = r_awaddr;
    assign awvalid = r_awvalid;
    assign wdata   = r_wdata;
    assign wstrb   = 4'hF;
    assign wvalid  = r_wvalid;
    assign araddr  = r_araddr;
    assign arvalid = r_arvalid;
    assign rready  = r_rready;

    // Instantiate DUT
    axi4_lite_slave dut (
        .aclk(clk),
        .aresetn(aresetn),
        .s_axi_awaddr(awaddr),
        .s_axi_awprot(3'b000),
        .s_axi_awvalid(awvalid),
        .s_axi_awready(awready),
        .s_axi_wdata(wdata),
        .s_axi_wstrb(wstrb),
        .s_axi_wvalid(wvalid),
        .s_axi_wready(wready),
        .s_axi_bresp(bresp),
        .s_axi_bvalid(bvalid),
        .s_axi_bready(bready),
        // Read Channels
        .s_axi_araddr(araddr),
        .s_axi_arprot(3'b000),
        .s_axi_arvalid(arvalid),
        .s_axi_arready(arready),
        .s_axi_rdata(rdata),
        .s_axi_rresp(rresp),
        .s_axi_rvalid(rvalid),
        .s_axi_rready(rready)
    );

    // Clock gen
    initial clk = 0;
    always #5 clk = ~clk;

    // VCD Dump & Time Format
    initial begin
        $timeformat(-9, 0, " ns", 10); // ns units, 0 decimals
        $dumpfile("dump.vcd");
        $dumpvars(0, axi4_lite_simple_tb);
    end

    initial begin
        $display("[@ %t] [INFO] Starting AXI4-Lite Slave Verification...", $time);
        // Async Reset
        aresetn = 0;
        r_awvalid = 0;
        r_wvalid = 0;
        r_arvalid = 0;
        r_rready = 1;
        bready = 1;
        #20 aresetn = 1;
        $display("[@ %t] [INFO] Reset Released.", $time);

        // --- TC_01: Single Word Write ---
        #10;
        r_awaddr = 5'h04;
        r_awvalid = 1;
        r_wdata = 32'hDEAD_BEEF;
        r_wvalid = 1;
        wait(awready && wready);
        @(posedge clk);
        r_awvalid = 0;
        r_wvalid = 0;
        wait(bvalid); 
        $display("[@ %t] [INFO] [TC_01] Write Handshake Successful: Addr=0x04, Data=0xDEADBEEF", $time);

        // --- TC_02: Single Word Read ---
        #20;
        r_araddr = 5'h04;
        r_arvalid = 1;
        wait(arready);
        @(posedge clk);
        r_arvalid = 0;
        wait(rvalid);
        $display("[@ %t] [INFO] [TC_02] Read Handshake Successful: Addr=0x04, RData=0x%h", $time, rdata);

        // --- TC_03: Data Integrity Check ---
        if (rdata == 32'hDEAD_BEEF)
            $display("[@ %t] [INFO] [TC_03] Data Integrity Check: PASSED", $time);
        else
            $display("[@ %t] [ERROR] [TC_03] Data Integrity Check: FAILED (Expected 0xDEADBEEF, Got 0x%h)", $time, rdata);

        #50;
        $display("[@ %t] [INFO] Simulation Finished.", $time);
        $finish;
    end

endmodule
