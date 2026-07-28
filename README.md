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
