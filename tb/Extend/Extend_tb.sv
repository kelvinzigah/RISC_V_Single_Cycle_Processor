`timescale 1ns / 1ps

module extend_tb ();

    logic [24:0] imm_in;
    logic [2:0] extend_ctrl;
    logic [31:0] imm_out;

    ImmExt uut(
        .ImmExt_In(imm_in),
        .ImmSrc(extend_ctrl),
        .ImmExt_Out(imm_out)
    );

    task assert_test(
        input string label,
        input logic [31:0] actual,
        input logic [31:0] expected
    ); begin
        $display("============================================");
        $display("Expected: %h", expected);
        $display("Actual  : %h", actual);
        if (actual !== expected)
            $display("%s: FAIL", label);
        else
            $display("%s: PASS", label);
        $display("============================================\\n");
    end
    endtask

    initial begin
        // I-Type (Positive)
        imm_in = 25'b000000000001_0000000000000; extend_ctrl = 3'b000; #10;
        assert_test("I-TYPE POS", imm_out, 32'h00000001);

        // I-Type (Max Pos)
        imm_in = 25'b011111111111_1111111111111; #10;
        assert_test("I-TYPE MAX POS", imm_out, 32'h000007FF);

        // I-Type (Max Neg)
        imm_in = 25'b100000000000_0000000000000; #10;
        assert_test("I-TYPE MAX NEG", imm_out, 32'hFFFFF800);

        // S-Type (Positive)
        imm_in = 25'b0000000_0000001111111_11111; extend_ctrl = 3'b001; #10;
        assert_test("S-TYPE POS", imm_out, 32'h0000001F);

        // S-Type(Negative)
        imm_in = 25'b1111100_0000001111111_10101; #10;
        assert_test("S-TYPE NEG", imm_out, 32'hffffff95);

        // B-Type (Positive)
        imm_in = 25'b0_000000_0000001111111_1111_1; extend_ctrl = 3'b010; #10;
        assert_test("B-TYPE POS", imm_out, 32'h00000081e);

        // B-Type (Negative)
        imm_in = 25'b1_000011_0000001111111_1111_0; #10;
        assert_test("B-TYPE NEG", imm_out, 32'hfffff07e);

        // U-Type
        imm_in = 25'b11111111111111111111_00000; extend_ctrl = 3'b011; #10;
        assert_test("U-TYPE MAX POS", imm_out, 32'hFFFFF000);

        // J-Type (Positive)
        imm_in = 25'b0_1111111111_1_11111111_11111; extend_ctrl = 3'b100; #10;
        assert_test("J-TYPE MAX POS", imm_out, 32'h0FFFFE);

        // J-Type (Negative)
        imm_in = 25'b1_0000000000_0_00000000_11111; #10;
        assert_test("J-TYPE MAX NEG", imm_out, 32'hfff00000);

        $finish;
    end

endmodule
