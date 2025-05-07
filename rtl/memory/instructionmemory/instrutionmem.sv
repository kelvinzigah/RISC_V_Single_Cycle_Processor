	module instruction_cache (
input logic [31:0] address_input,
output logic [31:0] data_output
);
//32'h00500113; // addi x2,x0,5
//32'h06602223; // sw x6,100(x0)
//32'h00190C37; // LUI x28, 0x00190000

always @(address_input) begin
        case (address_input)
            32'h00000000: data_output = 32'h01901337; // LUI x6,  0x00190000(d'102400 )
            32'h00000004: data_output = 32'h00190637; // LUI x12, 0x00190000
            32'h00000008: data_output = 32'h06602223; // sw x6,100(x0)
            32'h0000000C: data_output = 32'h0023E233; // or x4,x7,x2
            32'h00000010: data_output = 32'h0041F2B3; // and x5,x3,x4
            32'h00000014: data_output = 32'h004282B3; // add x5,x5,x4
            32'h00000018: data_output = 32'h02728863; // beq x5,x7,end
            32'h0000001C: data_output = 32'h0041A233; // slt x4,x3,x4
            32'h00000020: data_output = 32'h00020463; // beq x4,x0,around
            32'h00000024: data_output = 32'h00000293; // addi x5,x0,0 (shouldn't execute)
            32'h00000028: data_output = 32'h0023A233; // around: slt x4,x7,x2
            32'h0000002C: data_output = 32'h005203B3; // add x7,x4,x5
            32'h00000030: data_output = 32'h402383B3; // sub x7,x7,x2
            32'h00000034: data_output = 32'hFF718393; // addi x7,x3,-9
            32'h00000038: data_output = 32'h06002103; // lw x2,96(x0)
            32'h0000003C: data_output = 32'h005104B3; // add x9,x2,x5
            32'h00000040: data_output = 32'h008001EF; // jal x3,end
            32'h00000044: data_output = 32'h00100113; // addi x2,x0,1 (shouldn't execute)
            32'h00000048: data_output = 32'h00910133; // end: add x2,x2,x9
            32'h0000004C: data_output = 32'h0221A023; // sw x2,0x20(x3)
            32'h00000050: data_output = 32'h00210063; // done: beq x2,x2,done
            default: data_output = 32'h00000000; // don't care
        endcase
	$monitor(" Instruction Memory: The address input is - %h - and the instruction output is - %h - ", address_input , data_output);
    end

endmodule

//  prev0: 32'h00000004: data_output =  32'h00C00193; addi x3,x0,12
//  prev1: 32'h00000004: data_output = 32'h038000E7; //jalr pc -> 0x38
//  prev2: 32'h00000004: data_output =  32'h00C00193; addi x3,x0,12
//  prev3: 32'h00000004: data_output =  32'h6AE01337; // LUI x6,0x6AE01000
//  prev4:  32'h00000034: data_output = 32'h0471AA23; // sw x7,84(x3)
//  prev5: 32'h00000038: data_output = 32'h06002103; // lw x2,96(x0)
// prev6:  32'h00000004: data_output =  32'h03400067; //JALR pc -> 0x34
// prev7:  32'h00000004: data_output =  32'h02000067;  // jalr x0, 0x20(x0))
//prev8:  32'h00000004: data_output = 32'h6AE01337; // LUI x6,0x6AE01000