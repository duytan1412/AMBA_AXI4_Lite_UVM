# 🛡️ AMBA AXI4-Lite Slave UVM Verification Portfolio
[![UVM](https://img.shields.io/badge/Methodology-UVM--1.2-blue)](https://accellera.org/downloads/standards/uvm)
[![AXI4-Lite](https://img.shields.io/badge/Protocol-AMBA--AXI4--Lite-orange)](https://developer.arm.com/documentation/ihi0022/e/)

A comprehensive **UVM-based verification project** for an **AXI4-Lite Slave** IP. This portfolio project demonstrates the implementation of **Universal Verification Methodology (UVM)**, **Assertion-Based Verification (ABV)**, and **Functional Coverage (FCov)** principles.

---

## 🚀 Architectural Highlights

This environment is built with **Separation of Concerns (SoC)** and **Scalability** in mind:

*   **Complete UVM UVC**: Robust Agent-based architecture (Driver, Monitor, Sequencer).
*   **Dual-Layer Verification Strategy**:
    *   **Dynamic (UVM)**: Scoreboard-driven data integrity checks using associative arrays (Sparse Memory).
    *   **Static (ABV)**: 15+ SystemVerilog Assertions (SVA) for cycle-accurate protocol compliance.
*   **Functional Coverage (FCov)**: Comprehensive coverage models tracking Address Spaces, Byte Strobes, and AXI Response codes (OKAY vs SLVERR).
*   **CRV (Constrained-Random Verification)**: Advanced transaction randomization with soft constraints for flexible error injection.

---

## 🏗️ Verification Environment Architecture

```mermaid
graph TD
    subgraph TB ["UVM Testbench"]
        Test["UVM Test Library"] --> Env["UVM Environment"]
        Env --> Agent["AXI4-Lite Agent"]
        Env --> SB["Scoreboard"]
        Env --> Cov["Functional Coverage"]
        
        Agent --> SQr["Sequencer"]
        Agent --> Drv["Driver"]
        Agent --> Mon["Monitor"]
        
        Mon --> SB
        Mon --> Cov
    end

    subgraph HI ["Hardware Interface"]
        IF["AXI4-Lite Interface + SVA"]
    end

    subgraph RTL ["RTL Design"]
        DUT["AXI4-Lite Slave IP"]
    end

    Drv --> IF
    IF --> Drv
    Mon --> IF
    IF --> DUT
    DUT --> IF
```

---

## 📊 Verification Matrix (Test Plan)

| Test ID | Objective | Stimulus Type | Success Criteria |
| :--- | :--- | :--- | :--- |
| **base_test** | Verify basic R/W handshakes. | Randomized (Aligned) | 0 Scoreboard Errors. |
| **axi_error_test** | Verify SLVERR response on invalid address. | Targeted (Out-of-range) | `resp == 2'b10`. |
| **axi_burst_like_test**| Check pipeline stability with back-to-back reqs. | Randomized (No Delay) | No Protocol Violations. |
| **coverage_check** | Reach 100% Functional Coverage goals. | Random + Targeted | All bins covered. |

---

## 🎯 Functional Coverage Goals

The environment tracks the following metrics to ensure verification closure:
1.  **Address Space**: Coverage for all 4 register offsets and out-of-range boundaries.
2.  **Strobe Patterns**: Verification of partial word writes via `WSTRB`.
3.  **Response Codes**: Ensuring the Slave reacts correctly with `OKAY` and `SLVERR` under specific conditions.
4.  **Cross Coverage**: Ensuring every operation type (Read/Write) has been tested with every possible response code.

---

## 🛠️ Simulation & Deployment

### Toolchain Support
*   **EDA Tools**: Designed to be compatible with industry-standard simulators such as **Synopsys VCS**, **Cadence Xcelium**, and **Siemens Questa**.
*   **Web-based Analysis**: Fully compatible with [EDA Playground](https://edaplayground.com/).

### Execution Flow
```bash
# Example command for localized simulation (VCS)
vcs -sverilog -ntb_opts uvm -f filelist.f -R
```

---

> [!NOTE]
> This project was developed as a portfolio piece to demonstrate fundamental understanding of professional silicon-verification standards.
> **Developed by: Bì Duy Tân** (Junior Verification Engineer).
