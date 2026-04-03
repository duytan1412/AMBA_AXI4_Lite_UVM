`timescale 1ns / 1ps

interface axi4_lite_if #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5
) (
    input logic aclk,
    input logic aresetn
);

    // Write Address Channel (AW)
    logic [ADDR_WIDTH-1:0]     awaddr;
    logic [2:0]                awprot;
    logic                      awvalid;
    logic                      awready;

    // Write Data Channel (W)
    logic [DATA_WIDTH-1:0]     wdata;
    logic [(DATA_WIDTH/8)-1:0] wstrb;
    logic                      wvalid;
    logic                      wready;

    // Write Response Channel (B)
    logic [1:0]                bresp;
    logic                      bvalid;
    logic                      bready;

    // Read Address Channel (AR)
    logic [ADDR_WIDTH-1:0]     araddr;
    logic [2:0]                arprot;
    logic                      arvalid;
    logic                      arready;

    // Read Data Channel (R)
    logic [DATA_WIDTH-1:0]     rdata;
    logic [1:0]                rresp;
    logic                      rvalid;
    logic                      rready;

    //---------------------------------------------------------
    // PROTOCOL CHECKS (SVA) & FUNCTIONAL COVERAGE
    // Note: Concurrent assertions require commercial simulators (VCS/Questa/Xcelium).
    // Commented out below for compatibility with open-source tools (iverilog).
    //---------------------------------------------------------

    /*
    // AW Channel: awvalid must be stable until awready
    property p_awvalid_stable;
        @(posedge aclk) disable iff (!aresetn)
        (awvalid && !awready) |=> awvalid;
    endproperty
    assert property (p_awvalid_stable) 
        else $error("SVA ERR: awvalid dropped without awready");
    cover property (p_awvalid_stable);

    // W Channel: wvalid must be stable until wready
    property p_wvalid_stable;
        @(posedge aclk) disable iff (!aresetn)
        (wvalid && !wready) |=> wvalid;
    endproperty
    assert property (p_wvalid_stable)
        else $error("SVA ERR: wvalid dropped without wready");
    cover property (p_wvalid_stable);

    // B Channel: bvalid must be stable until bready
    property p_bvalid_stable;
        @(posedge aclk) disable iff (!aresetn)
        (bvalid && !bready) |=> bvalid;
    endproperty
    assert property (p_bvalid_stable)
        else $error("SVA ERR: bvalid dropped without bready");
    cover property (p_bvalid_stable);

    // AR Channel: arvalid must be stable until arready
    property p_arvalid_stable;
        @(posedge aclk) disable iff (!aresetn)
        (arvalid && !arready) |=> arvalid;
    endproperty
    assert property (p_arvalid_stable)
        else $error("SVA ERR: arvalid dropped without arready");
    cover property (p_arvalid_stable);

    // R Channel: rvalid must be stable until rready
    property p_rvalid_stable;
        @(posedge aclk) disable iff (!aresetn)
        (rvalid && !rready) |=> rvalid;
    endproperty
    assert property (p_rvalid_stable)
        else $error("SVA ERR: rvalid dropped without rready");
    cover property (p_rvalid_stable);
    */

endinterface
