# Scholarship Portfolio Summary

## IC Design Relevance
This repository demonstrates a UVM-based verification environment for an AXI4-Lite slave IP. It is the strongest IC Design / Design Verification portfolio project in this set because it combines AMBA protocol knowledge, UVM components, SVA/immediate assertions, scoreboard checking, targeted coverage closure, and documented waveform evidence.

## Verification Architecture
- DUT: AXI4-Lite slave with memory-mapped registers.
- UVM active agent: sequencer, driver, monitor.
- Scoreboard: expected-vs-actual data integrity checking.
- Assertions: VALID/READY stability, payload stability, response validity, and reset integrity.
- Coverage: address offsets, byte strobes, OKAY/SLVERR response codes, and handshake behavior.
- Tests: randomized base test, SLVERR error test, and burst-like back-to-back write/read test.

## Evidence Map
| Evidence | File |
| --- | --- |
| DUT RTL | `rtl/axi4_lite_slave.sv` |
| AXI4-Lite interface and assertions | `tb/if/axi4_lite_if.sv` |
| UVM test library | `tb/uvm/axi4_lite_test_lib.sv` |
| Functional coverage subscriber | `tb/uvm/axi4_lite_coverage.sv` |
| Simulation log | `sim_results/simulation.log` |
| Coverage closure report | `sim_results/coverage_report.txt` |
| Annotated waveform | `docs/waveform_annotated.png` |

## Test Plan Summary
| Test | Goal | Evidence |
| --- | --- | --- |
| `base_test` | Legal randomized read/write transactions | UVM log and scoreboard matches |
| `axi_error_test` | Invalid address produces SLVERR | `sim_results/simulation.log` |
| `axi_burst_like_test` | Consecutive register writes followed by reads | `tb/uvm/axi4_lite_test_lib.sv` and updated log evidence |
| Coverage closure | Cover address, WSTRB, response, and handshake bins | `sim_results/coverage_report.txt` |

## Scholarship Positioning
For Synopsys IC Design Scholarship review, lead with this repository. It maps cleanly to digital IC verification skills: UVM, SVA, AMBA AXI4-Lite, coverage-driven verification, waveform analysis, and protocol-debug thinking.
