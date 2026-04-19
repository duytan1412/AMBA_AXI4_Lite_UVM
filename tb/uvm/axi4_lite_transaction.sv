`ifndef AXI4_LITE_TRANSACTION_SV
`define AXI4_LITE_TRANSACTION_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class axi4_lite_transaction extends uvm_sequence_item;
    
    typedef enum { READ, WRITE } op_t;
    
    rand op_t          operation;
    rand logic [31:0]  addr;
    rand logic [31:0]  data;
    rand logic [3:0]   strb;
    rand logic [2:0]   prot;
    
    // Response fields
    logic [1:0]        resp;

    `uvm_object_utils_begin(axi4_lite_transaction)
        `uvm_field_enum(op_t, operation, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(strb, UVM_ALL_ON)
        `uvm_field_int(prot, UVM_ALL_ON)
        `uvm_field_int(resp, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "axi4_lite_transaction");
        super.new(name);
    endfunction

    // Constraints for 32-bit word alignment
    constraint c_aligned {
        soft addr[1:0] == 2'b00;
    }

    // Default protection (Unprivileged, Secure, Data)
    constraint c_prot { 
        soft prot == 3'b000; 
    }

    // Full strobe for 32-bit writes by default
    constraint c_strb {
        soft strb == 4'hF;
    }

    // Default address range for the 4 internal registers (0x0 to 0xF)
    constraint c_addr_range {
        soft addr[31:4] == 0;
    }

endclass

`endif
