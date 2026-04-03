`timescale 1ns / 1ps

module axi4_lite_slave #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5   // 5 bits enough for 4 registers (0x0, 0x4, 0x8, 0xC)
)(
    // Clock and Reset
    input  logic                      aclk,
    input  logic                      aresetn,

    // Write Address Channel (AW)
    input  logic [ADDR_WIDTH-1:0]     s_axi_awaddr,
    input  logic [2:0]                s_axi_awprot,
    input  logic                      s_axi_awvalid,
    output logic                      s_axi_awready,

    // Write Data Channel (W)
    input  logic [DATA_WIDTH-1:0]     s_axi_wdata,
    input  logic [(DATA_WIDTH/8)-1:0] s_axi_wstrb,
    input  logic                      s_axi_wvalid,
    output logic                      s_axi_wready,

    // Write Response Channel (B)
    output logic [1:0]                s_axi_bresp,
    output logic                      s_axi_bvalid,
    input  logic                      s_axi_bready,

    // Read Address Channel (AR)
    input  logic [ADDR_WIDTH-1:0]     s_axi_araddr,
    input  logic [2:0]                s_axi_arprot,
    input  logic                      s_axi_arvalid,
    output logic                      s_axi_arready,

    // Read Data Channel (R)
    output logic [DATA_WIDTH-1:0]     s_axi_rdata,
    output logic [1:0]                s_axi_rresp,
    output logic                      s_axi_rvalid,
    input  logic                      s_axi_rready
);

    //-----------------------------------------
    // Internal Signals
    //-----------------------------------------
    logic [ADDR_WIDTH-1:0] awaddr_reg;
    logic [ADDR_WIDTH-1:0] araddr_reg;
    
    // 4 memory-mapped control registers
    logic [DATA_WIDTH-1:0] slv_reg0;
    logic [DATA_WIDTH-1:0] slv_reg1;
    logic [DATA_WIDTH-1:0] slv_reg2;
    logic [DATA_WIDTH-1:0] slv_reg3;

    logic slv_reg_wren;
    logic slv_reg_rden;
    
    localparam RESP_OKAY   = 2'b00;
    localparam RESP_SLVERR = 2'b10;

    //-----------------------------------------
    // Write Channel Logic (AW and W handshaking)
    //-----------------------------------------
    // Accept address and data when both are valid and we are not busy sending a B-response
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b0;
        end else begin
            if (~s_axi_awready && s_axi_awvalid && s_axi_wvalid && ~s_axi_bvalid) begin
                s_axi_awready <= 1'b1;
                s_axi_wready  <= 1'b1;
                awaddr_reg    <= s_axi_awaddr; // Latch the write address
            end else begin
                s_axi_awready <= 1'b0;
                s_axi_wready  <= 1'b0;
            end
        end
    end

    // Write Enable signal (1 cycle pulse when both ready and valid are true)
    assign slv_reg_wren = s_axi_wready && s_axi_wvalid && s_axi_awready && s_axi_awvalid;

    // Perform actual write to registers using WSTRB
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            slv_reg0 <= '0;
            slv_reg1 <= '0;
            slv_reg2 <= '0;
            slv_reg3 <= '0;
        end else if (slv_reg_wren) begin
            // Address decoding (assuming 32-bit registers, word-aligned)
            case (awaddr_reg[3:2])
                2'h0: begin
                    for (int byte_index = 0; byte_index <= (DATA_WIDTH/8)-1; byte_index++) begin
                        if (s_axi_wstrb[byte_index] == 1)
                            slv_reg0[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
                    end
                end
                2'h1: begin
                    for (int byte_index = 0; byte_index <= (DATA_WIDTH/8)-1; byte_index++) begin
                        if (s_axi_wstrb[byte_index] == 1)
                            slv_reg1[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
                    end
                end
                2'h2: begin
                    for (int byte_index = 0; byte_index <= (DATA_WIDTH/8)-1; byte_index++) begin
                        if (s_axi_wstrb[byte_index] == 1)
                            slv_reg2[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
                    end
                end
                2'h3: begin
                    for (int byte_index = 0; byte_index <= (DATA_WIDTH/8)-1; byte_index++) begin
                        if (s_axi_wstrb[byte_index] == 1)
                            slv_reg3[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
                    end
                end
            endcase
        end
    end

    // Generation of B-Response
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            s_axi_bvalid <= 1'b0;
            s_axi_bresp  <= 2'b0;
        end else begin
            if (slv_reg_wren && ~s_axi_bvalid) begin
                s_axi_bvalid <= 1'b1;
                s_axi_bresp  <= RESP_OKAY; // Always OKAY for valid 4 registers range
            end else if (s_axi_bready && s_axi_bvalid) begin
                s_axi_bvalid <= 1'b0;
            end
        end
    end

    //-----------------------------------------
    // Read Channel Logic (AR and R handshaking)
    //-----------------------------------------
    // Accept read address when valid and not busy
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            s_axi_arready <= 1'b0;
            araddr_reg    <= '0;
        end else begin
            if (~s_axi_arready && s_axi_arvalid && ~s_axi_rvalid) begin
                s_axi_arready <= 1'b1;
                araddr_reg    <= s_axi_araddr;
            end else begin
                s_axi_arready <= 1'b0;
            end
        end
    end

    // Read Enable signal
    assign slv_reg_rden = s_axi_arready & s_axi_arvalid & ~s_axi_rvalid;

    // Read Data output multiplexer
    logic [DATA_WIDTH-1:0] reg_data_out;
    always_comb begin
        case (araddr_reg[3:2])
            2'h0: reg_data_out = slv_reg0;
            2'h1: reg_data_out = slv_reg1;
            2'h2: reg_data_out = slv_reg2;
            2'h3: reg_data_out = slv_reg3;
            default: reg_data_out = '0; 
        endcase
    end

    // Generation of Read Valid and Read Response
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            s_axi_rvalid <= 1'b0;
            s_axi_rresp  <= 2'b0;
            s_axi_rdata  <= '0;
        end else begin
            if (slv_reg_rden) begin
                s_axi_rvalid <= 1'b1;
                s_axi_rresp  <= RESP_OKAY;
                s_axi_rdata  <= reg_data_out;
            end else if (s_axi_rready && s_axi_rvalid) begin
                s_axi_rvalid <= 1'b0;
            end
        end
    end

endmodule
