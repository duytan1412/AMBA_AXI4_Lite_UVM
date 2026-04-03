`timescale 1ns / 1ps

module axi4_lite_simple_tb();

    reg clk;
    reg rst_n;

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

    // Master-side registers for stimulus generation
    reg [4:0]  r_awaddr;
    reg        r_awvalid;
    reg [31:0] r_wdata;
    reg        r_wvalid;

    assign awaddr  = r_awaddr;
    assign awvalid = r_awvalid;
    assign wdata   = r_wdata;
    assign wstrb   = 4'hF;
    assign wvalid  = r_wvalid;

    // Instantiate DUT
    axi4_lite_slave dut (
        .aclk(clk),
        .aresetn(rst_n),
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
        // Connect others to 0/dummy
        .s_axi_araddr(5'h0),
        .s_axi_arprot(3'b000),
        .s_axi_arvalid(1'b0),
        .s_axi_rready(1'b0)
    );

    // Clock gen
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Async Reset
        rst_n = 0;
        r_awvalid = 0;
        r_wvalid = 0;
        bready = 1;
        #20 rst_n = 1;

        // --- Basic Write Handshake Simulation ---
        #10;
        r_awaddr = 5'h04;
        r_awvalid = 1;      // Drive address
        r_wdata = 32'hAAAA_BBBB;
        r_wvalid = 1;      // Drive data
        
        // Wait for Slave READY handshake
        wait(awready && wready);
        @(posedge clk);
        r_awvalid = 0;
        r_wvalid = 0;

        #50;
        $display("Simulation Done: AXI Handshake successful.");
        $finish;
    end

endmodule
