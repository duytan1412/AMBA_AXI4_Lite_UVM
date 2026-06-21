# AXI4-Lite Slave Verification Plan

## Scope

Verify an AXI4-Lite slave register block for protocol stability, data integrity, error response behavior, and basic back-to-back access handling.

## Traceability Matrix

| Requirement | Verification Method | Test | Coverage / Check | Evidence |
|---|---|---|---|---|
| AW/W/B/AR/R valid signals remain stable until ready | SVA protocol properties | `base_test`, `axi_burst_like_test` | `p_awvalid_stable`, `p_wvalid_stable`, `p_bvalid_stable`, `p_arvalid_stable`, `p_rvalid_stable` | `tb/if/axi4_lite_if.sv` |
| Aligned register writes are readable | Scoreboard memory model | `base_test` | write/read data compare | `tb/uvm/axi4_lite_scoreboard.sv` |
| Invalid address returns `SLVERR` | Directed sequence + response check | `axi_error_test` | response code observation | `tb/uvm/axi4_lite_test_lib.sv` |
| Back-to-back accesses keep protocol stable | Randomized no-delay sequence | `axi_burst_like_test` | no SVA errors, no scoreboard mismatch | `sim_results/regression_summary.txt` |
| Address, strobe, operation, and response space are observed | Functional covergroups | all tests | covergroup bins in source | `tb/uvm/axi4_lite_coverage.sv` |

## Review Notes

- Full UVM execution requires VCS, Xcelium, Questa, or another simulator with UVM support.
- The open-source CI path is intentionally limited to syntax/smoke checks because Icarus Verilog does not provide full UVM library support.
- Coverage percentages must be regenerated from simulator coverage databases before being presented as closure metrics.
