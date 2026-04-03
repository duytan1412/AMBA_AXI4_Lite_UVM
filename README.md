# AXI4-Lite Slave RTL & ABV Verification

A protocol-compliant **AMBA AXI4-Lite Slave** implementation in SystemVerilog. This project demonstrates **Assertion-Based Verification (ABV)** for interface integrity and functional correctness.

## Technical Specifications

The design implements a 4-register bank (32-bit width) supporting the AXI4-Lite 5-channel handshake:
- **Asynchronous Reset**: Uses `aresetn` (Active-Low) for asynchronous initialization of all protocol registers.
- **Write Path**: Supports `AW` (Address) and `W` (Data) phases with `WSTRB` (byte-enable) logic.
- **Read Path**: Independent `AR` (Address) and `R` (Data/Status) synchronization.
- **Handshake Logic**: Fully compliant with AXI4 stability rules (VALID must remain high until READY is asserted).

## Verification (ABV & Directed TB)

This project uses SystemVerilog Assertions (SVA) to monitor protocol compliance.

### Protocol Checkers (SVA)
The `axi4_lite_if.sv` contains assertions to validate:
- Handshake stability (no dropping VALID before READY).
- Reset-to-idle state transitions.
- Response (`BRESP`/`RRESP`) validity.

> [!NOTE]
> Concurrent assertions are implemented but commented out in the source for compatibility with open-source tools (Icarus Verilog). These are fully functional on commercial simulators like VCS or Questa.

### Test Scenarios
- **TC_01 (Write)**: Write `0xDEADBEEF` to register offset `0x04`.
- **TC_02 (Read)**: Read back from register offset `0x04`.
- **TC_03 (Data Integrity)**: Verify read-back value matches the original write.

## Simulation & Results

### Annotated Waveform (Vivado Logic Analyzer)
![AXI4-Lite Waveform](docs/waveform_annotated.png)
*Figure 1: Timing diagram showing TC_01 (Write), TC_02 (Read Address), and TC_03 (Data Verified).*

### Execution Log (iverilog)
```text
[@ 0 ns] [INFO] Starting AXI4-Lite Slave Verification...
[@ 20000 ns] [INFO] Reset Released.
[@ 35000 ns] [INFO] [TC_01] Write Handshake Successful: Addr=0x04, Data=0xDEADBEEF
[@ 65000 ns] [INFO] [TC_02] Read Handshake Successful: Addr=0x04, RData=0xdeadbeef
[@ 65000 ns] [INFO] [TC_03] Data Integrity Check: PASSED
[@ 115000 ns] [INFO] Simulation Finished.
```

## Project Limitations
- **Directed Testbench**: Current verification uses fixed stimulus.
- **No Randomization**: Constrained-random stimulus is not yet implemented.
- **Open-Source Constraints**: Full SVA and Coverage metrics require commercial EDA tools (Xcelium/VCS).

## Roadmap
- **Phase 1 (Current)**: RTL + ABV + Directed TB.
- **Phase 2 (Planned)**: Build a full UVM 1.2 environment (Agent, Scoreboard, and Sequences).
- **Phase 3**: Multi-slave interconnect integration.

## Usage
```bash
make sim   # Run verification log
make waves # View waveforms (GTKWave)
```

## License
MIT
