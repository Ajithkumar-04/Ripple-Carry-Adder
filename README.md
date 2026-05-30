# An Efficient Ripple Carry Adder Using Pipelining

A 4-bit Ripple Carry Adder (RCA) implemented in Verilog with Fine-Grain Pipelining to minimize critical path delay, designed and simulated on AMD Vivado 2023.2.



---

## Overview

The Ripple Carry Adder is one of the most fundamental digital arithmetic circuits, but its carry propagation delay — O(n) — limits its performance in high-speed applications. This project applies **Fine-Grain Pipelining** to break the critical path within each Full Adder into smaller sub-circuits, reducing the overall time delay from **5.919 ns** to **4.680 ns**.

Five configurations are implemented and compared to identify the most optimal balance between speed, LUT usage, and flip-flop count.

---

## Architecture

### Base: Unpipelined RCA
Four 1-bit Full Adders connected in series. The carry-out of each Full Adder feeds directly into the next as carry-in, with no registers in between.

### Fine-Grain Pipelining
Each Full Adder is internally divided into 3 logic levels:
- **Level 1** — XOR and AND of inputs X, Y
- **Level 2** — XOR and AND of Level 1 outputs with carry-in
- **Level 3** — OR to generate carry-out

Registers clocked on the positive edge of `clk` are inserted between these levels within every Full Adder, breaking the critical path and reducing time delay.

### Additional Pipeline Levels (L1, L2, L3)
On top of Fine-Grain, pipeline registers are also added between Full Adder stages at the top-level RCA:
- **Level 1** — Registers after FA1; pipelines `S[0]` and dependent variables
- **Level 2** — Registers after FA1 and FA2; also pipelines `S[1]`
- **Level 3** — Registers after FA1, FA2, and FA3; also pipelines `S[2]`

---

## File Structure

```
├── rpa_no_pip.v     # Unpipelined 4-bit Ripple Carry Adder
├── rpa_fg.v         # Fine-Grain Pipelined RCA (optimized)
├── rpa_l1.v         # Fine-Grain + Level 1 Pipelined RCA
├── rpa_l2.v         # Fine-Grain + Level 2 Pipelined RCA
├── rpa_l3.v         # Fine-Grain + Level 3 Pipelined RCA
└── README.md
```

---

## Performance Results

Simulated on **AMD Vivado 2023.2**.

| Stage | LUTs | Flip-Flops | Time Delay (ns) |
|---|---|---|---|
| Unpipelined | 4 | 0 | 5.919 |
| **Fine-Grain (FG) Pipelined** | **11** | **20** | **4.680** |
| FG + Level 1 Pipelined | 13 | 25 | 4.680 |
| FG + Level 2 Pipelined | 12 | 31 | 4.680 |
| FG + Level 3 Pipelined | 12 | 35 | 4.680 |

**Key finding:** Fine-Grain Pipelining alone achieves the maximum delay reduction. Adding further pipeline levels (L1, L2, L3) increases flip-flop and LUT usage without any meaningful improvement to the critical path — making **`rpa_fg.v` the optimal design**.

---

## Module Description

### `rpa_no_pip.v` — Unpipelined RCA
```
rippe_adder(X[3:0], Y[3:0], S[3:0], Co)
└── fulladder × 4  (pure combinational, no registers)
```

### `rpa_fg.v` — Fine-Grain Pipelined RCA *(recommended)*
```
rippe_adder(X[3:0], Y[3:0], S[3:0], Co, clk)
└── fulladder × 4  (registers between Level 1 → 2 → 3)
```
Each `fulladder` uses registers `L1–L6` clocked on `posedge clk` to pipeline the three internal logic levels.

### `rpa_l1.v`, `rpa_l2.v`, `rpa_l3.v`
Progressive addition of inter-stage pipeline registers at the top-level RCA module, building on top of Fine-Grain Pipelining.

---

## Simulation

1. Open **AMD Vivado 2023.2** (or later)
2. Create a new RTL project and add the desired `.v` file
3. Set `rippe_adder` as the top module
4. Run **Behavioral Simulation** to verify functional correctness
5. Run **Synthesis** to view LUT and Flip-Flop utilization
6. Run **Report Timing Summary** (unconstrained path) to see the critical path delay

To compare all configurations, repeat steps 2–6 for each file.

---

## Key Takeaways

- Fine-Grain Pipelining reduces the critical path delay by **~21%** (5.919 ns → 4.680 ns)
- Adding more pipeline levels beyond Fine-Grain yields **no further timing improvement** but increases resource usage
- The Fine-Grain approach is **modular and scalable** — it can be extended to any n-bit RCA by simply applying the same intra-FA pipelining to all n Full Adders
- For combination with other circuits, Fine-Grain alone is preferred to keep power consumption minimal

---

## Applications

- DSP processors and FIR/IIR filter implementations
- Vedic multiplier arithmetic units
- IoT and low-power VLSI systems
- Any combinational circuit requiring a fast, area-efficient adder

---

## References

1. L. Wanhammar, *DSP Integrated Circuits*, Academic Press, 1999
2. B. Fjellborg, "A general framework for extraction of VLSI pipeline structures," *Microprocessing and Microprogramming*, vol. 28, 1990
3. A. Khan et al., "Carry look-ahead and ripple carry method based 4-bit carry generator circuit," *Microelectronics Journal*, vol. 140, 2023
4. K. P. Kumar and A. Kanhe, "A two stage pipeline architecture for hardware implementation," *Microprocessors and Microsystems*, vol. 108, 2024

---

## Authors

**Deepan Kumaar A · Giriprasath T.K. · Ajithkumar P.R · Senthamizh Selvi R**  
Department of ECE, Easwari Engineering College, Chennai, Tamil Nadu – 600089

*Published at INNOVA 2024 | DOI: 10.1109/INNOVA63080.2024.10847016*
