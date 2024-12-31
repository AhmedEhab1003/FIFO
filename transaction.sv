class transaction #(parameter DATA_WIDTH = 32);

  // Input signals to be randomized
  rand logic  reset ;
  rand logic  Wr_enable ;
  rand logic  Read_enable;
  rand logic [DATA_WIDTH-1:0] data_in;

  // Constructor Initialization
  function new();
    this.reset = 0;
    this.Wr_enable = 0;
    this.Read_enable = 0;
    this.data_in = 0;
  endfunction


  // Randomization Constraints

  constraint a    { data_in [7:0]  inside {[100:230]}; }
  constraint b    { data_in [15:8] inside {[200:255]}; }

  constraint cdef {
    data_in [23:16] dist {[0:99] :/30, [100:199] :/60, [200:255] :/10}; }
  
  constraint g { 
    if (data_in [7:0] > 150) 
      data_in [DATA_WIDTH-1:DATA_WIDTH-8] inside {[0:50]};
    else
      data_in [DATA_WIDTH-1:DATA_WIDTH-8] inside {[0:255]}; }

  constraint h {Read_enable dist {0:=80, 1:=20};     // 50% read
                Wr_enable   dist {0:=20, 1:=80};     // 50% write
                reset       dist {0:=90, 1:=10} ;}   // 10% reset
  
  constraint k { unique {Wr_enable,Read_enable}; } // assumed for convenience
endclass