interface fifo_interface #(parameter
                           ADDR_WIDTH  = 5,
                           DATA_WIDTH  = 8,
                           fifo_size   = 2**ADDR_WIDTH) (input bit clk);
  logic  reset;
  logic  full, empty ;
  logic  Wr_enable , Read_enable ;
  logic [DATA_WIDTH-1:0] data_in ;
  logic [DATA_WIDTH-1:0] data_out;

  clocking cb @(posedge clk); 

    // in/out directions based on Testbench
    default input #1ns output #0ns;
    output Wr_enable, Read_enable, data_in;
    input  full, empty, data_out;
  endclocking

  // testbench modport with async reset
  modport tb  (clocking cb, output reset);

endinterface