module top;

  parameter ADDR_WIDTH = 2;
  parameter DATA_WIDTH = 32;
  parameter NUM_LOOPS  = 1000;
  parameter fifo_size  = 2**ADDR_WIDTH ;

  bit clk;
  always #5 clk = ~ clk;  // clock generation

  // Components Instances
  fifo_interface #(ADDR_WIDTH,DATA_WIDTH)            fifo_io  (clk);
  testbench      #(ADDR_WIDTH,DATA_WIDTH,NUM_LOOPS)  tb   (fifo_io);
  FIFO           #(ADDR_WIDTH,DATA_WIDTH)            dut 
  (.clk            (fifo_io.clk),
   .reset          (fifo_io.reset),
   .Wr_enable      (fifo_io.Wr_enable),
   .Read_enable    (fifo_io.Read_enable),
   .data_in        (fifo_io.data_in),
   .data_out       (fifo_io.data_out),
   .full           (fifo_io.full),
   .empty          (fifo_io.empty));

  //Required Assertion
  Assertion1: assert property ( 
    @(posedge fifo_io.clk) 
    disable iff ( $past (dut.write_ptr[ADDR_WIDTH-1:0]) == fifo_size-1  || fifo_io.reset)
    (fifo_io.Wr_enable && !fifo_io.full) |=>
    dut.write_ptr == $past(dut.write_ptr)+1  );

  //Bonus Assertion to check if reset clears output signals
  Assertion2: assert property (
    @(posedge fifo_io.clk) 
    fifo_io.reset |-> ##[0:2](!fifo_io.full && fifo_io.empty && !fifo_io.data_out));

 //Bonus Assertion to ensure empty and full flags never raised togather
  Assertion3: assert property (
    @(posedge fifo_io.clk) 
    !(fifo_io.full && fifo_io.empty) );


  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;
  end
endmodule