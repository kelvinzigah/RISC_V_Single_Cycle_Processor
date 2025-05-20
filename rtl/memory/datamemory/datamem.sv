module datamem(
  input  logic        clk,
  input  logic        WriteEn,
  input  logic [31:0] address,
  input  logic [31:0] datain,
  input  logic        datatype,    // '0' = signed, '1' = unsigned for half/byte loads
  input  logic        reset,
  input  logic [1:0]  datasize,    // 00=word, 01=half, 10=byte

  output logic [31:0] dataout
);

 //64 x 32-bit memory array
  logic [31:0] RAM [0:63];

  // Synchronous reset + writes
  always_ff @(posedge clk) begin
    if (reset) begin
      // clear entire memory
      for (int i = 0; i < 64; i++)
        RAM[i] <= 32'h00000000;
    end
    else if (WriteEn) begin
      int idx;
	idx = address[31:2];  //word alligned index
      unique case (datasize)
        2'b00: begin
          // full word
          RAM[idx] <= datain;
        end

        2'b01: begin
         //half word
          if (address[1] == 1'b0)
            RAM[idx][15:0] <= datain[15:0];
          else
            RAM[idx][31:16] <= datain[15:0];
        end

        2'b10: begin
          // byte
          unique case (address[1:0])
            2'b00: RAM[idx][ 7: 0] <= datain[7:0];
            2'b01: RAM[idx][15: 8] <= datain[7:0];
            2'b10: RAM[idx][23:16] <= datain[7:0];
            2'b11: RAM[idx][31:24] <= datain[7:0];
          endcase
        end

        default: ; // no action
      endcase
	$display("WRITE------MemWrite: %b, DataType: %b , DataSize: %b, address: %h , DataIn: %h ", WriteEn, datatype, datasize, address, datain);
    end
  end

  // Asynchronous read + sign/zero extension
  always_comb begin
    int idx;
    logic [31:0] word;
	idx = address[31:2];
	word = RAM[idx];

    unique case (datasize)
      2'b00: begin// word
        
        dataout = word;
      end

      2'b01: begin //half word
        logic [15:0] half;
        logic        signbit;
	
	//1. load word
        if (address[1] == 1'b0) begin
          half    = word[15:0];
          signbit = word[15];
        end else begin
          half    = word[31:16];
          signbit = word[31];
        end

	//2. load sign and read
        if (datatype == 1'b0) begin
          // signed
          dataout = {{16{signbit}}, half};
        end else begin
          // unsigned
          dataout = {16'b0, half};
        end
      end

      2'b10: begin // byte
        logic [7:0] bytes;
        logic       signbit;
	
	//1.load byte
        unique case (address[1:0])
          2'b00: begin bytes = word[ 7: 0]; signbit = word[ 7]; end
          2'b01: begin bytes = word[15: 8]; signbit = word[15]; end
          2'b10: begin bytes = word[23:16]; signbit = word[23]; end
          2'b11: begin bytes = word[31:24]; signbit = word[31]; end
        endcase

	//2. load sign and read
        if (datatype == 1'b0) begin
          // signed
          dataout = {{24{signbit}}, bytes};
        end else begin
          // unsigned
          dataout = {24'b0, bytes};
        end
      end

      default: dataout = 32'b0;
    endcase
	$display("READ---MemWrite: %b, DataType: %b , DataSize: %b, address: %h , DataIn: %h, DataOut ", WriteEn, datatype, datasize, address, datain, dataout);
  end

endmodule

