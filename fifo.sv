module FIFO #(parameter
              ADDR_WIDTH  = 5,
              DATA_WIDTH  = 8,
              fifo_size   = 2**ADDR_WIDTH)
  (
    input clk, 
    input reset,
    input Wr_enable,
    input reg [DATA_WIDTH-1:0] data_in,
    input Read_enable,
    output reg full,
    output reg empty,
    output reg [DATA_WIDTH-1:0] data_out
  );

  reg wrap_around;
  reg [DATA_WIDTH-1:0] ram [fifo_size-1:0];
  reg [ADDR_WIDTH:0] write_ptr,read_ptr;

  assign wrap  = write_ptr[ADDR_WIDTH] ^ read_ptr[ADDR_WIDTH];
  assign full  = wrap & (write_ptr[ADDR_WIDTH-1:0] == read_ptr[ADDR_WIDTH-1:0]);
  assign empty = (write_ptr == read_ptr);

    always @(posedge clk or posedge reset)begin

      if(reset)begin
        for(int i=0; i<fifo_size; i=i+1) begin
          ram[i]<=0;
        end
        data_out  <= 0;
        write_ptr <= 0;
        read_ptr  <= 0;
      end  

      else if((Wr_enable == 1) && (~full)&&(Read_enable == 0)) begin
        ram[write_ptr[ADDR_WIDTH-1:0]] <= data_in;
        write_ptr = write_ptr+1;
      end

      else if((Read_enable == 1) && (~empty)&&(Wr_enable == 0))begin
        data_out <= ram[read_ptr[ADDR_WIDTH-1:0]];
        read_ptr = read_ptr+1;
      end

    end   
endmodule