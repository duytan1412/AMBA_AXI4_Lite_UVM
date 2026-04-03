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
    // SYSTEMVERILOG ASSERTIONS (SVA)
    // Professional verification code included for JD alignment
    //---------------------------------------------------------

    property p_awvalid_stable;
        @(posedge aclk) disable iff (!aresetn)
        (awvalid && !awready) |=> awvalid;
    endproperty
    assert property (p_awvalid_stable) 
        else $error("SVA VIOLATION: awvalid dropped without awready");

    property p_wvalid_stable;
        @(posedge aclk) disable iff (!aresetn)
        (wvalid && !wready) |=> wvalid;
    endproperty
    assert property (p_wvalid_stable)
        else $error("SVA VIOLATION: wvalid dropped without wready");

    property p_bvalid_stable;
        @(posedge aclk) disable iff (!aresetn)
        (bvalid && !bready) |=> bvalid;
    endproperty
    assert property (p_bvalid_stable)
        else $error("SVA VIOLATION: bvalid dropped without bready");

    property p_arvalid_stable;
        @(posedge aclk) disable iff (!aresetn)
        (arvalid && !arready) |=> arvalid;
    endproperty
    assert property (p_arvalid_stable)
        else $error("SVA VIOLATION: arvalid dropped without arready");

    property p_rvalid_stable;
        @(posedge aclk) disable iff (!aresetn)
        (rvalid && !rready) |=> rvalid;
    endproperty
    assert property (p_rvalid_stable)
        else $error("SVA VIOLATION: rvalid dropped without rready");

endinterface
