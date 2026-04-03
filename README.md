# AXI4-Lite Slave RTL & ABV Verification

A protocol-compliant **AMBA AXI4-Lite Slave** implementation in SystemVerilog. This project demonstrates **Assertion-Based Verification (ABV)** for interface integrity and functional correctness.

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
| **Protocol** | AXI4-Lite Standard | ✅ Core features implemented & verified |
| | Handshake Stability | ✅ Verified via ABV (VALID/READY) |
| | Response Handling | ✅ OKAY (00) for BRESP/RRESP |
| **Logic** | Address Decoding | ✅ 5-bit Sub-addressing |
| | Register Read/Write | ✅ 4 x 32-bit Registers |
| | Asynchronous Reset | ✅ `aresetn` (Active-Low) |
| **Verification** | Methodology | ✅ 3 directed verification scenarios |
| | Assertion-Based (ABV) | ✅ Basic SVA Protocol Checkers |
| | Simulation Logging | ✅ Timestamped (ns) |

## Verification (ABV & Directed TB)

This project uses SystemVerilog Assertions (SVA) to monitor protocol compliance.

### Protocol Checkers (SVA)
The `axi4_lite_if.sv` contains assertions to validate:
- Handshake stability (no dropping VALID before READY).
- Reset-to-idle state transitions.
- Response (`BRESP`/`RRESP`) validity.

> [!NOTE]
> Concurrent assertions are implemented but commented out in the source for compatibility with open-source tools (Icarus Verilog). Full concurrent SVA checking is intended for commercial simulators such as VCS or Questa.

## Simulation & Results

### Annotated Simulation Waveform (XSim/GTKWave)
![AXI4-Lite Waveform](docs/waveform_annotated.png)
*Figure 1: Timing diagram showing TC_01 (Write), TC_02 (Read Address), and TC_03 (Data Verified).*

### Execution Log (iverilog)
```text
[@ 0 ns] [INFO] Starting AXI4-Lite Slave Verification...
[@ 20 ns] [INFO] Reset Released.
[@ 45 ns] [INFO] [TC_01] Write Handshake Successful: Addr=0x04, Data=0xDEADBEEF
[@ 75 ns] [INFO] [TC_02] Read Handshake Successful: Addr=0x04, RData=0xdeadbeef
[@ 75 ns] [INFO] [TC_03] Data Integrity Check: PASSED
[@ 125 ns] [INFO] Simulation Finished.
```

## Project Limitations
- **Directed Testbench**: Uses fixed stimulus, covering basic path transitions.
- **Functional Coverage**: Missing constrained-random stimulus and functional coverage (Planned for Phase 2).
- **Tool Compatibility**: Basic simulation runs on Icarus; industrial SVA features require commercial EDA tools.

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
