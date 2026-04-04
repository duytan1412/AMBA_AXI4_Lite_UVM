# AXI4-Lite Slave Verification Project (UVM Migration In-Progress)

A protocol-compliant **AMBA AXI4-Lite Slave** design in SystemVerilog. This repository currently implements **Assertion-Based Verification (ABV)** and directed test scenarios as part of Phase 1 of a full UVM migration.

## Project Structure

```text
├── rtl/
│   └── axi4_lite_slave.sv      # AXI4-Lite Slave Logic (Async Reset)
├── tb/
│   ├── axi4_lite_simple_tb.sv    # Main Testbench (Directed Stimulus)
│   └── if/                       # Interface & ABV Layer
│       └── axi4_lite_if.sv       # Interface with SVA Protocol Checkers
├── docs/
│   └── waveform_annotated.png    # Annotated simulation results
├── Makefile                      # Icarus Verilog build & sim flow
└── README.md                     # Project documentation
```

## Technical Specifications

The design implements a 4-register bank (32-bit width) supporting the AXI4-Lite 5-channel handshake:
- **Asynchronous Reset**: Uses `aresetn` (Active-Low) for asynchronous initialization of all protocol registers.
- **Write Path**: Supports `AW` (Address) and `W` (Data) phases with `WSTRB` (byte-enable) logic.
- **Read Path**: Independent `AR` (Address) and `R` (Data/Status) synchronization.
- **Handshake Logic**: Fully compliant with AXI4 stability rules (VALID must remain high until READY is asserted).

## Features Checklist

| Category | Feature | Status |
| :--- | :--- | :--- |
| **Protocol** | AXI4-Lite Standard | ✅ Core features implemented |
| | Handshake Stability | ✅ Basic scenarios verified via ABV |
| | Response Handling | ✅ OKAY (00) for BRESP/RRESP |
| **Logic** | Address Decoding | ✅ 5-bit Sub-addressing |
| | Register Read/Write | ✅ 4 x 32-bit Registers |
| | Asynchronous Reset | ✅ `aresetn` (Active-Low) |
| **Verification** | Methodology | ✅ ABV + Directed Testbench |
| | **Assertion-Based (ABV)** | ✅ **20 Immediate Assertions (Icarus Compatible)** |
| | **Handshake Integrity** | ✅ **Logic verified under directed scenarios** |
| | Simulation Logging | ✅ Timestamped (ns) with ERROR/INFO levels |

## 🚀 Verification (ABV & Directed TB)

This project leverages 15+ SystemVerilog Assertions (SVA) to monitor protocol compliance. 

### SVA/Immediate Property Categories
The interface checkers (`axi4_lite_if.sv`) implement **20 specific protocol properties**:
- **Handshake Stability (5 properties)**: Ensures `VALID` signals (AW, W, AR, R, B) stay high until `READY`.
- **Signal Stability (5 properties)**: Payload (`ADDR`, `DATA`, `RESP`) must be stable during `VALID`.
- **Response Legality (3 properties)**: Validates `BRESP`/`RRESP` values and `WSTRB` integrity.
- **Reset Integrity (7 properties)**: Validates that all `VALID` signals stay low and states reset during `aresetn`.

### EDA Tool Support & Compatibility
> **Verification Note:**
> The testbench utilizes 15+ **Immediate Assertions** to validate protocol integrity and handshake stability, ensuring full compatibility and execution on Icarus Verilog. Full *Concurrent SVA* blocks are also included in the source code (currently commented out) for seamless portability to commercial EDA tools (VCS/Questa).

## Simulation & Results

### Execution Log (Icarus Verilog)
```text
[@ 0 ns] [INFO] Starting AXI4-Lite Slave Verification...
[@ 20 ns] [INFO] Reset Released.
[@ 45 ns] [INFO] [TC_01] Write Handshake Successful: Addr=0x04, Data=0xDEADBEEF
[@ 75 ns] [INFO] [TC_02] Read Handshake Successful: Addr=0x04, RData=0xdeadbeef
[@ 75 ns] [INFO] [TC_03] Data Integrity Check: PASSED
[@ 125 ns] [INFO] Simulation Finished.
```

## Known Gaps & Limitations
- **Directed Stimulus**: The current testbench uses directed test cases. Transitioning to Constrained Random (Phase 2).
- **Concurrent SVA**: Full concurrent checking is tool-dependent (optimized for VCS/Xcelium).
- **Read/Write Collisions**: Handlers for simultaneous read/write to the same register bank are currently simplified.

## Roadmap
- **Phase 1 (Done)**: RTL + ABV + Directed TB + Async Reset.
- **Phase 2 (Planned)**: Full UVM 1.2 Environment implementation (Agent, Scoreboard, and Sequences).
- **Phase 3**: Multi-master/Multi-slave Interconnect validation.

## Usage
```bash
make sim   # Run verification log
make waves # View waveforms (GTKWave)
```

## License
MIT
