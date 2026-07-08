# AXI4-Lite Valid-Ready SVA Examples

## Intent

AXI4-Lite channels use `valid` and `ready` handshakes. If a source asserts `valid` while sink `ready` is low, `valid` must stay asserted until handshake completes.

## Existing Assertion Pattern

`tb/if/axi4_lite_if.sv` contains one stability property per channel:

| Channel | Property | Failure meaning |
|---|---|---|
| AW | `p_awvalid_stable` | write address source dropped request before `awready` |
| W | `p_wvalid_stable` | write data source dropped request before `wready` |
| B | `p_bvalid_stable` | slave dropped write response before `bready` |
| AR | `p_arvalid_stable` | read address source dropped request before `arready` |
| R | `p_rvalid_stable` | slave dropped read data before `rready` |

## Pass Scenario

1. Source asserts `valid`.
2. Sink keeps `ready=0` for one or more cycles.
3. Source holds `valid=1` and keeps payload stable.
4. Handshake completes when `valid && ready` is true.

## Fail Scenario

1. Source asserts `valid`.
2. Sink keeps `ready=0`.
3. Source drops `valid` before handshake.
4. Assertion reports channel-specific protocol error.

## Debug Flow

- Check whether failing channel is master-driven or slave-driven.
- Check payload stability around the same cycle, not only `valid`.
- Compare driver intent, monitor observation, and DUT pins before calling it a DUT bug.
