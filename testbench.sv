
module testbench #(parameter
                   ADDR_WIDTH  = 5,
                   DATA_WIDTH  = 8,
                   NUM_LOOPS   = 100,
                   fifo_size   = 2**ADDR_WIDTH)(fifo_interface.tb  fifo_if);

  covergroup cov;
    coverpoint fifo_if.cb.empty;
    coverpoint fifo_if.cb.full ;
  endgroup
  //_______________________________________________________________________

  bit [DATA_WIDTH-1:0] scoreboard [$];
  bit [DATA_WIDTH-1:0] temp_out;
  int scoreboard_size;
  transaction  #(DATA_WIDTH) packet;
  cov cov_ins;
  int loop;
  //_______________________________________________________________________
  initial begin
    packet  = new();
    cov_ins = new();
    fifo_if.reset = 1;
    @fifo_if.cb;
    fifo_if.reset = 0;
    cov_ins.sample();
    repeat (NUM_LOOPS) begin
      loop ++;
      assert (packet.randomize());  // bonus assertion to ensure randomization
      //$display ("@%4tns  nLOOP = %0d  , %p",$time,loop,packet);
      drive (packet);
      write_scoreboard(packet);
      cov_ins.sample();
    end
    repeat (3) @fifo_if.cb;
    $display ("Total Coverage = %0d%%" , cov_ins.get_coverage());
    $finish;
  end
  //__________________________________________________________________________

  task drive (transaction packet);  // Driver Role
    fifo_if.reset          <= packet.reset ;
    fifo_if.cb.Wr_enable   <= packet.Wr_enable ;
    fifo_if.cb.Read_enable <= packet.Read_enable ;
    fifo_if.cb.data_in     <= packet.data_in;
    @fifo_if.cb;
    fifo_if.cb.Wr_enable   <= 0 ;
    fifo_if.cb.Read_enable <= 0 ;
  endtask
  //__________________________________________________________________________
  task write_scoreboard (transaction packet);

    if (packet.reset) begin
      repeat (1) @fifo_if.cb;
      scoreboard = {};
    end

    else begin         
      // write and not full
      if (packet.Wr_enable && scoreboard.size() < fifo_size) 
        begin
          repeat (2) @fifo_if.cb;
          // FIFO behavior (first in)
          scoreboard.push_front(packet.data_in);
          scoreboard_size = scoreboard.size();
          verify_flag();
        end
      
      // read and not empty
      if (packet.Read_enable && scoreboard.size() > 0 )
        begin
          repeat (2) @fifo_if.cb;
          // FIFO behavior (first out)
          temp_out = scoreboard.pop_back();
          scoreboard_size = scoreboard.size();
          verify_out();
          verify_flag();
        end
    end
  endtask
  //_______________________________________________________________
  task verify_out();
    if (!(temp_out === fifo_if.cb.data_out)) begin
      $error ("\033[31mError in Loop %0d",loop);
      $write ("\033[31mscoreboard = %8h ",temp_out);
      $display (", actual = %8h",fifo_if.cb.data_out);
    end
    //     else begin
    //       $write ("\033[32mscoreboard = %8h ",temp_out);
    //       $display (", actual = %8h",fifo_if.cb.data_out);
    //     end
  endtask
  //________________________________________________________________
  task verify_flag();
    if ((scoreboard_size == 0) && (!fifo_if.cb.empty)) begin
      $error  ("\033[31mError in Loop %0d",loop);
      $display ("\033[31mEmpty Flag Error !");
    end
    if ((scoreboard_size == fifo_size) && (!fifo_if.cb.full)) begin
      $error ("\033[31mError in Loop %0d",loop);
      $display ("\033[31mFull Flag Error !");
    end
  endtask
endmodule
