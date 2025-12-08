`timescale 1ns/1ps

module Sign_Extend_tb;
    reg [31:0] IR;
    reg [2:0] SE_Control;
    wire [31:0] imm;

    Sign_Extend dut (
        .IR(IR),
        .SE_Control(SE_Control),
        .imm(imm)
    );

    initial begin
        $dumpfile("Sign_Extend_tb.vcd");
        $dumpvars(0, Sign_Extend_tb);

        // ----------------------------------------------------
        // Test I-type
        // imm = -1
        // ----------------------------------------------------
        IR = 32'b1111_1111_1111_00000_000_00000_0000011;   // imm = -1
        SE_Control = 3'd0;
        #10;
        $display("I-type imm = %0d (0x%h)", $signed(imm), imm);

        // ----------------------------------------------------
        // Test S-type:
        // imm = 5
        // ----------------------------------------------------
        IR = 32'b0000000_0000000000_000_00101_0010011; 
        SE_Control = 3'd1;
        #10;
        $display("S-type imm = %0d (0x%h)", $signed(imm), imm);

        // ----------------------------------------------------
        // Test B-type
        // imm = 1250
        // ----------------------------------------------------
        IR = 32'b0_100111_00000_00000_000_00010_1111111; 
        SE_Control = 3'd2;
        #10;
        $display("B-type imm = %0d (0x%h)", $signed(imm), imm);

        // ----------------------------------------------------
        // Test U-type:
        // ----------------------------------------------------
        IR = 32'hABCDE123;  // imm = 0xABCDE000
        SE_Control = 3'd3;
        #10;
        $display("U-type imm = %0d (0x%h)", $signed(imm), imm);

        // ----------------------------------------------------
        // Test J-type
        // imm = 4
        // ----------------------------------------------------
        IR = 32'b0_0000000010_0_0000000000_00000_11011;  
        SE_Control = 3'd4;
        #10;
        $display("J-type imm = %0d (0x%h)", $signed(imm), imm);

        // ----------------------------------------------------
        $display("----- Simulation Finished -----");
        $finish;
    end

endmodule
