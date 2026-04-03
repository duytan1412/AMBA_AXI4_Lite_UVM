# AXI4-Lite Slave RTL & ABV Verification

A protocol-compliant **AMBA AXI4-Lite Slave** implementation in SystemVerilog, featuring an **Assertion-Based Verification (ABV)** suite for interface integrity and functional correctness.

## Technical Specifications

The design implements a 4-register bank (32-bit width) with full support for the AXI4-Lite 5-channel handshake protocol:
- **Write Channels**: Support for simultaneous `AW` (Address Write) and `W` (Data Write) phases with `WSTRB` (partial write) support.
- **Read Channels**: Independent `AR` (Address Read) and `R` (Data Read) synchronization.
- **Protocol Stability**: Handshake logic ensures `VALID` signals remain stable until acknowledged by `READY` (Slave logic).
- **Reset Management**: Synchronous reset handling to drive all protocol signals to idle states.

## Verification Methodology (ABV)

This repository utilizes **Assertion-Based Verification (ABV)** to monitor interface compliance in real-time. 

### Protocol Checkers (SVA)
The SystemVerilog Interface (`axi4_lite_if.sv`) includes assertions for:
- `awvalid` / `wvalid` / `arvalid` stability during wait states.
- `bvalid` / `rvalid` handshake edges.
- Reset-to-idle state transitions.

> [!NOTE]
> Concurrent assertions and functional coverage (`cover property`) are implemented in the interface but wrapped for compatibility with open-source tools (Icarus Verilog). These are fully operational on commercial simulators (VCS/Questa).

### Test Plan & Scenarios
Verification is performed via a directed SystemVerilog testbench (`axi4_lite_simple_tb.sv`).
- **TC_01 (Async Reset)**: Verifies all bus signals are de-asserted during and after reset.
- **TC_02 (Single Write)**: Executes a 32-bit write transaction to register offset `0x04`.
- **TC_03 (Single Read)**: Executes a 32-bit read transaction from register offset `0x04`.
- **TC_04 (Data Integrity)**: Compares Read data against previously Written data to ensure core logic correctness.

## Simulation Results

### Waveform Analysis
The waveform below illustrates the 5-channel handshake sequence for a successful Write followed by a Read operation.

![AXI4-Lite Handshake](docs/axi_handshake.png)

### Execution Log
Sample output from `make sim` using `iverilog`:
```text
[TEST] Starting AXI4-Lite Slave Verification...
[TEST] Reset Released.
[TC_01] Write Handshake Successful: Addr=0x04, Data=0xDEADBEEF
[TC_02] Read Handshake Successful: Addr=0x04, RData=0xdeadbeef
[TC_03] Data Integrity Check: PASSED
[TEST] Simulation Finished.
```

## Project Roadmap

- **Phase 1 (Current)**: RTL + ABV (SVA) + Directed Testbench.
- **Phase 2 (Planned)**: Full UVM 1.2 Migration (Agent, Sequencer, Scoreboard, and Constrained-Random stimulus).
- **Phase 3**: Integration with AXI-to-APB Bridge.

## Usage

### Prerequisites
- **Icarus Verilog** (v11+)
- **GTKWave** (for waveform viewing)

### Running Simulation
```bash
make sim   # Compile and run verification sequence
make waves # View signals in GTKWave
```

## License
MIT License.
