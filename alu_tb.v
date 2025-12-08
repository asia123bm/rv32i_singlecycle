module alu_tb;

    // Parameters
    localparam WIDTH = 32;
    localparam OPCODE_WIDTH = 5;

    reg [OPCODE_WIDTH - 1: 0] tb_Op_ALU;
    reg [WIDTH - 1: 0] tb_A;
    reg [WIDTH - 1: 0] tb_B;
    
    wire [WIDTH - 1: 0] tb_ALU_result;
    wire tb_flag;

    // ALU Opcode Definitions (for readability)
    localparam CHECK_EQ        = 5'b00000; // check if equal
    localparam CHECK_GT        = 5'b00001; // check if greater than (signed)
    localparam CHECK_GT_UNSIGN = 5'b00010; // check if gt unsign
    localparam CHECK_LT        = 5'b00011; // check if less than (signed)
    localparam CHECK_LT_UNSIGN = 5'b00100; // check if less than unsigned
    localparam CHECK_LT_EQ     = 5'b00101; // check if lt or eq
    localparam CHECK_NOT_EQ    = 5'b00110; // check if not equal
    localparam SRA             = 5'b10111; // shift right arithmetic
    localparam SLL             = 5'b11000; // shift left
    localparam SRL             = 5'b11001; // shift right (logical)
    localparam ADD             = 5'b11010; // add
    localparam SUB             = 5'b11011; // sub
    localparam XOR             = 5'b11100; // xor
    localparam AND             = 5'b11101; // and
    localparam NOR             = 5'b11110; // nor
    localparam NAND            = 5'b11111; // nand
    localparam OR              = 5'b10000; // or

    // Instantiate the Device Under Test (DUT)
    ALU #(
        .WIDTH(WIDTH)
    ) dut (
        .A(tb_A),
        .B(tb_B),
        .Op_ALU(tb_Op_ALU),
        .ALU_result(tb_ALU_result),
        .flag(tb_flag)
    );

    task run_test;
        input [OPCODE_WIDTH-1:0] op;
        input [WIDTH-1:0] a;
        input [WIDTH-1:0] b;
        input [30:0] test_id; // Added ID for tracking
        
        begin
            tb_Op_ALU = op;
            tb_A = a;
            tb_B = b;
            #10; 
            $display("TID=%0d | OP=%b | A=%h | B=%h | Result=%h | Flag=%b", 
                     test_id, op, a, b, tb_ALU_result, tb_flag);
        end
    endtask

    // Test execution
    initial begin
        $display("--- Starting ALU Testbench (100 Cases) ---");
        
        // Initialize inputs
        tb_A = 0; tb_B = 0; tb_Op_ALU = 0; #10;
        
        // --- TEST CASE 1-15: COMPARISONS (Check Flags) ---
        
        // 1-3. CHECK_EQ (A=B, A!=B, Neg=Neg)
        run_test(CHECK_EQ, 32'h00000005, 32'h00000005, 1);//flag = 1
        run_test(CHECK_EQ, 32'hFFFFFFFF, 32'h00000000, 2);//flag = 0
        run_test(CHECK_EQ, 32'h80000000, 32'h80000000, 3);//flag = 1
        
        // 4-6. CHECK_GT (Signed: Pos > Pos, Neg > Pos, Pos < Neg)
        run_test(CHECK_GT, 32'h0000000A, 32'h00000005, 4);//flag = 1
        run_test(CHECK_GT, 32'hFFFFFFFF, 32'h00000000, 5);//flag = 0
        run_test(CHECK_GT, 32'h7FFFFFFF, 32'h80000000, 6); //flag = 1
        
        // 7-9. CHECK_GT_UNSIGN (Unsigned: Max > 1, Pos < Neg)
        run_test(CHECK_GT_UNSIGN, 32'hFFFFFFFF, 32'h00000001, 7);//flag = 1
        run_test(CHECK_GT_UNSIGN, 32'h80000000, 32'h00000001, 8);//flag = 1
        run_test(CHECK_GT_UNSIGN, 32'h00000000, 32'hFFFFFFFF, 9);//flag = 0
        
        // 10-12. CHECK_LT (Signed: Pos < Pos, Neg < Pos, Pos > Neg)
        run_test(CHECK_LT, 32'h00000005, 32'h0000000A, 10);
        run_test(CHECK_LT, 32'hFFFFFFFF, 32'h00000000, 11); // -1 < 0 -> True
        run_test(CHECK_LT, 32'h7FFFFFFF, 32'h80000000, 12); // MaxPos < MinNeg -> False
        
        // 13-15. CHECK_NOT_EQ
        run_test(CHECK_NOT_EQ, 32'h00000001, 32'h00000002, 13);
        run_test(CHECK_NOT_EQ, 32'h0000000F, 32'h0000000F, 14);
        run_test(CHECK_NOT_EQ, 32'h80000000, 32'h7FFFFFFF, 15);
        
        // --- TEST CASE 16-30: SHIFTS ---
        
        // 16-20. SRA (Arithmetic Shift Right)
        run_test(SRA, 32'hFFFFFFFF, 32'h00000002, 16); // -1 >> 2 = -1
        run_test(SRA, 32'h80000000, 32'h00000001, 17); // MinNeg >> 1
        run_test(SRA, 32'h0000000A, 32'h00000003, 18); // Pos >> 3
        run_test(SRA, 32'hFFFFFFFF, 32'h0000001F, 19); // Shift -1 by 31
        run_test(SRA, 32'h80000000, 32'h00000005, 20); // Shift MinNeg by 5
        
        // 21-25. SLL (Logical Shift Left)
        run_test(SLL, 32'h00000001, 32'h0000001F, 21); // Shift 1 by 31
        run_test(SLL, 32'h0000000C, 32'h00000002, 22);
        run_test(SLL, 32'h80000000, 32'h00000001, 23); // MSB shifts out
        run_test(SLL, 32'hAAAAAAAA, 32'h00000004, 24);
        run_test(SLL, 32'h0000000F, 32'h00000000, 25); // Shift by 0
        
        // 26-30. SRL (Logical Shift Right)
        run_test(SRL, 32'hFFFFFFFF, 32'h00000001, 26); // LSR -1 by 1
        run_test(SRL, 32'h0000000F, 32'h00000004, 27);
        run_test(SRL, 32'h80000000, 32'h00000001, 28); // LSR MinNeg by 1 (MSB -> 0)
        run_test(SRL, 32'hFFFFFFFF, 32'h0000001F, 29); // LSR Max by 31
        run_test(SRL, 32'h0000000A, 32'h00000000, 30); // Shift by 0
        
        // --- TEST CASE 31-50: ADD/SUB ---
        
        // 31-35. ADD (Addition)
        run_test(ADD, 32'h00000001, 32'h00000001, 31);
        run_test(ADD, 32'h7FFFFFFF, 32'h00000001, 32); // MaxPos + 1 (Overflow)
        run_test(ADD, 32'hFFFFFFFF, 32'h00000001, 33); // -1 + 1 = 0
        run_test(ADD, 32'h80000000, 32'hFFFFFFFF, 34); // MinNeg + -1
        run_test(ADD, 32'h00000000, 32'h00000000, 35);
        
        // 36-40. SUB (Subtraction)
        run_test(SUB, 32'h00000005, 32'h00000001, 36);
        run_test(SUB, 32'h80000000, 32'h00000001, 37); // MinNeg - 1 (Overflow)
        run_test(SUB, 32'h00000000, 32'h00000001, 38); // 0 - 1 = -1
        run_test(SUB, 32'h00000001, 32'hFFFFFFFF, 39); // 1 - (-1) = 2
        run_test(SUB, 32'h7FFFFFFF, 32'hFFFFFFFF, 40); // MaxPos - (-1)
        
        // 41-50. Mixed ADD/SUB/Overflow
        run_test(ADD, 32'h40000000, 32'h40000000, 41);
        run_test(SUB, 32'h00000000, 32'h80000000, 42); // 0 - MinNeg
        run_test(ADD, 32'h80000000, 32'h00000000, 43);
        run_test(SUB, 32'h7FFFFFFF, 32'h80000000, 44); // MaxPos - MinNeg
        run_test(ADD, 32'hFFFFFFFF, 32'h80000000, 45); // -1 + MinNeg
        run_test(SUB, 32'h00000000, 32'h00000000, 46);
        run_test(ADD, 32'h11111111, 32'hAAAAAAAA, 47);
        run_test(SUB, 32'hAAAAAAAA, 32'h11111111, 48);
        run_test(ADD, 32'h80000000, 32'h80000000, 49); // MinNeg + MinNeg
        run_test(SUB, 32'h00000000, 32'h00000000, 50);

        // --- TEST CASE 51-70: LOGIC OPS ---
        
        // 51-55. XOR
        run_test(XOR, 32'hAAAAAAAA, 32'h55555555, 51); // Result: All 1s
        run_test(XOR, 32'hFFFFFFFF, 32'h00000000, 52);
        run_test(XOR, 32'h0000000F, 32'h0000000F, 53); // Result: All 0s
        run_test(XOR, 32'h7FFFFFFF, 32'h80000000, 54); // MaxPos XOR MinNeg
        run_test(XOR, 32'h12345678, 32'hFEDCBA98, 55); // A XOR (~A)
        
        // 56-60. AND
        run_test(AND, 32'hFFFFFFFF, 32'h80000000, 56); // Max AND MinNeg
        run_test(AND, 32'h00000001, 32'h00000002, 57); // Result: 0
        run_test(AND, 32'hAAAAAAAA, 32'hBBBBBBBB, 58);
        run_test(AND, 32'h0000000F, 32'hFFFFFFF0, 59); // Result: 0
        run_test(AND, 32'hFFFFFFFF, 32'hFFFFFFFF, 60);
        
        // 61-65. OR
        run_test(OR, 32'h7FFFFFFF, 32'h80000000, 61); // Result: All 1s
        run_test(OR, 32'h00000001, 32'h00000002, 62);
        run_test(OR, 32'h00000000, 32'hFFFFFFFF, 63);
        run_test(OR, 32'hAAAAAAAA, 32'hBBBBBBBB, 64);
        run_test(OR, 32'h0F0F0F0F, 32'hF0F0F0F0, 65); // Result: All 1s
        
        // 66-70. NOR
        run_test(NOR, 32'hFFFFFFFF, 32'hFFFFFFFF, 66); // Result: 0
        run_test(NOR, 32'h00000000, 32'h00000000, 67); // Result: All 1s
        run_test(NOR, 32'h00000001, 32'h00000002, 68);
        run_test(NOR, 32'h80000000, 32'h00000001, 69);
        run_test(NOR, 32'h7FFFFFFF, 32'h80000000, 70); // Result: 0

        // --- TEST CASE 71-100: MIXED & BOUNDARY ---
        
        // 71-75. NAND
        run_test(NAND, 32'hFFFFFFFF, 32'hFFFFFFFF, 71); // Result: 0
        run_test(NAND, 32'h00000000, 32'h00000000, 72); // Result: All 1s
        run_test(NAND, 32'h00000001, 32'h00000002, 73); // Result: All 1s
        run_test(NAND, 32'h7FFFFFFF, 32'h80000000, 74);
        run_test(NAND, 32'hAAAAAAAA, 32'hBBBBBBBB, 75);
        
        // 76-80. Shift Boundary Checks
        run_test(SRA, 32'h00000001, 32'h00000020, 76); // Shift by >= WIDTH
        run_test(SLL, 32'hFFFFFFFF, 32'h00000021, 77); // Shift by > WIDTH
        run_test(SRL, 32'h80000000, 32'h0000001F, 78); // Shift by 31
        run_test(SLL, 32'h00000000, 32'h00000005, 79); // Shift 0
        run_test(SRA, 32'hFFFFFFFF, 32'h00000000, 80); // Shift by 0
        
        // 81-90. Comparison Edge Cases
        run_test(CHECK_GT, 32'h00000001, 32'hFFFFFFFF, 81); // 1 > -1 -> True
        run_test(CHECK_LT, 32'h00000001, 32'hFFFFFFFF, 82); // 1 < -1 -> False
        run_test(CHECK_GT_UNSIGN, 32'h00000001, 32'hFFFFFFFF, 83); // 1 > Max -> False
        run_test(CHECK_LT_UNSIGN, 32'h00000001, 32'hFFFFFFFF, 84); // 1 < Max -> True
        run_test(CHECK_EQ, 32'h00000000, 32'h00000000, 85);
        run_test(CHECK_NOT_EQ, 32'h00000000, 32'h00000000, 86);
        run_test(CHECK_LT_EQ, 32'h00000000, 32'h00000000, 87);
        run_test(CHECK_LT_EQ, 32'hFFFFFFFF, 32'h00000000, 88); // -1 < 0 -> True
        run_test(CHECK_LT_EQ, 32'h00000000, 32'hFFFFFFFF, 89); // 0 < -1 -> False
        run_test(CHECK_LT_EQ, 32'h00000001, 32'h00000001, 90);
        
        // 91-100. Miscellaneous Arithmetic/Logic
        run_test(ADD, 32'h00000001, 32'h80000000, 91);
        run_test(SUB, 32'h80000000, 32'h80000000, 92); // MinNeg - MinNeg = 0
        run_test(XOR, 32'hAAAAAAAA, 32'hAAAAAAAA, 93);
        run_test(AND, 32'h0F0F0F0F, 32'hF0F0F0F0, 94);
        run_test(OR, 32'h10101010, 32'h01010101, 95);
        run_test(NOR, 32'h11111111, 32'h22222222, 96);
        run_test(NAND, 32'hFFFF0000, 32'h0000FFFF, 97);
        run_test(ADD, 32'h10000000, 32'h20000000, 98);
        run_test(SUB, 32'hF0000000, 32'h0F000000, 99);
        run_test(SLL, 32'h00000001, 32'h00000000, 100);

        $display("--- Testbench Finished ---");
        #10 ;
    end

endmodule