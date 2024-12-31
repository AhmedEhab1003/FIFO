# FIFO Design and Verification

This project implements and verifies a First-In-First-Out (FIFO) memory module using SystemVerilog. 
The design includes a parameterized FIFO module, a testbench for functional verification, and a top-level module integrating the design and the testbench.


## Project Structure

### 1. `fifo.sv`
- Implements the FIFO design with the following features:
  - **Parameters**: `ADDR_WIDTH`, `DATA_WIDTH`, and `fifo_size`.
  - **Inputs**: `clk`, `reset`, `Wr_enable`, `Read_enable`, `data_in`.
  - **Outputs**: `data_out`, `full`, `empty`.
  - Handles full and empty flag generation and wrap-around for circular buffer behavior.

### 2. `testbench.sv`
- Verifies the FIFO design using a UVM-like verification environment with:
  - Randomized transactions for writing and reading data.
  - Functional coverage for `empty` and `full` signals.
  - Scoreboard for output data validation.
  - Assertions for error detection and flag verification.
  - Tasks:
    - **Drive transactions**: Simulates write and read operations.
    - **Scoreboard update**: Keeps track of expected data.
    - **Verification tasks**: Compares actual and expected outputs.

### 3. `top.sv`
- Integrates the FIFO design and the testbench.
- Includes assertions for design validation:
  - Write pointer increment under valid conditions.
  - Reset behavior validation.
  - Ensures `full` and `empty` flags are not asserted simultaneously.
- Generates a waveform file for post-simulation analysis.



## Parameters

| Parameter    | Description                       | Default Value  |
|--------------|-----------------------------------|----------------|
| `ADDR_WIDTH` | Address width for the FIFO        | 5              |
| `DATA_WIDTH` | Data width of each FIFO entry     | 8              |
| `fifo_size`  | Size of the FIFO in entries       | `2**ADDR_WIDTH`|
| `NUM_LOOPS`  | Number of test iterations         | 100            |




 **Expected Outputs**:
   - Coverage results are printed in the terminal.
   - Any assertion failures or mismatches are logged as errors.
   - Visualize FIFO behavior using the waveform file.

---

## Features Tested

- Functional correctness of `write` and `read` operations.
- Handling of `full` and `empty` conditions.
- Reset functionality.
- Design corner cases (e.g., simultaneous `full` and `empty` flags).

---

## Future Enhancements

- Extend testbench to use a complete UVM methodology.
- Add performance metrics (latency, throughput).
- Support for burst transactions.


## Run on EDA Playground
 edaplayground.com/x/q8H9
