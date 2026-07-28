# AMBA-AHB-APB-Bus-Verification-Environment


A UVM-based verification environment for an AMBA AHB-Lite bus fabric
bridged to an APB peripheral subsystem — validating multi-master AHB
arbitration, burst/split/retry transfer handling, and correct
protocol-compliant bridging into the low-power APB domain used to
access on-chip peripherals and control/status registers.


## Overview

- **DUT**: multi-master AHB-Lite bus (configurable master/slave count)
  with a round-robin/priority arbiter, plus an AHB-to-APB bridge
  fronting N APB peripheral slaves
- **AHB protocol coverage**: single and burst transfers (INCR,
  INCR4/8/16, WRAP4/8/16), pipelined address/data phases, SPLIT/RETRY
  response handling, HRESP error injection, back-to-back master
  arbitration hand-off
- **APB protocol coverage**: SETUP/ACCESS phase sequencing, PSTRB byte
  enables, PSLVERR propagation back through the bridge, bridge wait-
  state insertion while an APB transfer is outstanding
- **Multi-master stimulus**: independent per-master agents generating
  concurrent, overlapping bus requests to exercise arbitration fairness
  and priority ordering under contention
- **Reference model**: a transaction-level predictor for expected
  arbiter grant order and expected AHB↔APB transaction mapping, used
  for scoreboard comparison
- **Functional coverage**: burst-type × master-ID cross coverage,
  arbitration contention scenarios, SPLIT/RETRY sequences, APB error
  response paths, back-to-back same-master vs. different-master grants
- **Assertions (SVA)**: protocol-legality checks — no new address phase
  while HREADY is low, HTRANS/HBURST/HSIZE combinations stay legal
  throughout a burst, APB PENABLE always follows exactly one PSETUP
  cycle, grant never changes mid-burst without a legal split



## Verification Environment Architecture

```
                        ┌──────────────────────┐
                        │   Test (uvm_test)     │  selects sequence(s),
                        │                        │  configures env
                        └───────────┬───────────┘
                                    ▼
                        ┌──────────────────────┐
                        │  Virtual Sequencer    │
                        └───────────┬───────────┘
                                    ▼
     ┌──────────────────────────────Env──────────────────────────────┐
     │  ┌─────────────────┐  ┌─────────────────┐                     │
     │  │ ahb_master_agent │  │ ahb_master_agent │  ...  (N masters)  │
     │  │ (driver/mon/seqr)│  │ (driver/mon/seqr)│                    │
     │  └────────┬────────┘  └────────┬────────┘                     │
     │           └──────────┬─────────┘                              │
     │                      ▼                                        │
     │           ┌─────────────────────┐                             │
     │           │  ahb_slave_agent(s)  │  memory/peripheral targets  │
     │           └──────────┬──────────┘                             │
     │                      ▼                                        │
     │           ┌─────────────────────┐                             │
     │           │  apb_agent (passive) │  monitors bridge -> APB     │
     │           │  per peripheral      │  slave transactions         │
     │           └──────────┬──────────┘                             │
     │                      ▼                                        │
     │           ┌─────────────────────┐                             │
     │           │  Reference Model     │  predicts grant order +     │
     │           │                      │  AHB<->APB txn mapping      │
     │           └──────────┬──────────┘                             │
     │                      ▼                                        │
     │           ┌─────────────────────┐                             │
     │           │    Scoreboard        │                            │
     │           └──────────┬──────────┘                             │
     │                      ▼                                        │
     │           ┌─────────────────────┐                             │
     │           │ Coverage Collector   │                            │
     │           └─────────────────────┘                             │
     └──────────────────────────────────────────────────────────────┘
```

---

## Repository Structure

```
amba-ahb-apb-verif/
├── README.md
├── LICENSE
├── .gitignore
├── Makefile                          
├── docs/
│   ├── dut_spec.md                   
│   ├── verification_plan.md          
│   ├── testplan_to_coverage_map.md   
│   └── env_architecture.md           
│
├── rtl/
│   └── dut/
│       ├── ahb_arbiter.sv            
│       ├── ahb_decoder.sv            
│       ├── ahb_to_apb_bridge.sv
│       └── apb_peripheral_stub.sv    
│
├── verif/
│   ├── uvm/
│   │   ├── agents/
│   │   │   ├── ahb_master_agent/
│   │   │   │   ├── ahb_master_driver.sv
│   │   │   │   ├── ahb_master_monitor.sv
│   │   │   │   ├── ahb_master_sequencer.sv
│   │   │   │   └── ahb_master_item.sv
│   │   │   ├── ahb_slave_agent/
│   │   │   │   ├── ahb_slave_driver.sv       
│   │   │   │   └── ahb_slave_monitor.sv
│   │   │   └── apb_agent/
│   │   │       └── apb_monitor.sv            
│   │   ├── env/
│   │   │   ├── ahb_apb_env.sv
│   │   │   ├── ahb_apb_env_config.sv
│   │   │   ├── ahb_apb_virtual_sequencer.sv
│   │   │   ├── arbiter_ref_model.sv         
│   │   │   ├── bridge_ref_model.sv          
│   │   │   ├── ahb_apb_scoreboard.sv
│   │   │   └── ahb_apb_coverage.sv
│   │   ├── sequences/
│   │   │   ├── virtual_seq/
│   │   │   │   ├── base_vseq.sv
│   │   │   │   ├── multi_master_contention_vseq.sv
│   │   │   │   ├── burst_sweep_vseq.sv       
│   │   │   │   ├── split_retry_vseq.sv
│   │   │   │   └── error_injection_vseq.sv
│   │   │   └── master_seq/
│   │   │       └── ahb_master_seq_lib.sv
│   │   └── tests/
│   │       ├── ahb_apb_base_test.sv
│   │       ├── smoke_test.sv
│   │       ├── arbitration_fairness_test.sv
│   │       ├── burst_sweep_test.sv
│   │       ├── split_retry_test.sv
│   │       ├── error_propagation_test.sv
│   │       └── regression_test_list.f
│   └── sva/
│       ├── ahb_protocol_assertions.sv        
│       ├── apb_protocol_assertions.sv        
│       └── bridge_assertions.sv              
│
├── sim/
│   ├── questasim/
│   │   └── run_uvm.do
│   └── vcs/
│       └── run.sh
│
├── regression/
│   ├── run_regression.py             
│   ├── coverage_merge.py
│   └── report_gen.py                 
│
├── scripts/
│   └── waveform_gen.sh
```

---
