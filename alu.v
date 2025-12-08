/*
+-------+----------------------+
| OPCODE| DISCRIPTION          |
+-------+----------------------+
| 00010 | A == B               |
| 00000 | A > B                |
| 00001 | A > B (unsigned)     |
| 00011 | A < B                |
| 00100 | A < B (unsigned)     |
| 00101 | A <= B               |
| 00110 | A != B               |
| 10111 | A >>> B              |
| 11000 | A << B               |
| 11001 | A >> B               |
| 11010 | A + B                |
| 11011 | A - B                |
| 11100 | A xor B              |
| 11101 | A and B              |
| 11110 | A nor B              |
| 11111 | A nand B             |
| 10000 | A or B               |
+-------+----------------------+
*/





module ALU #(
    parameter WIDTH = 32
) (
    input       [WIDTH - 1: 0]  A,
    input       [WIDTH - 1: 0]  B,
    input       [4: 0]          Op_ALU,
    output  reg [WIDTH - 1: 0]  ALU_result,
    output  reg                 flag
);


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

    wire signed [WIDTH - 1: 0] shift_right_a    = $signed(A) >>> B;
    wire [WIDTH - 1: 0] shift_right             = A >> B;
    wire [WIDTH - 1: 0] shift_left              = A << B;
    wire signed [WIDTH - 1: 0] add              = $signed(A) + $signed(B);
    wire signed [WIDTH - 1: 0] sub              = $signed(A) - $signed(B);
    wire [WIDTH - 1: 0] xo_r                    = A ^ B;
    wire [WIDTH - 1: 0] an_d                    = A & B;
    wire [WIDTH - 1: 0] no_r                    = ~(A | B);
    wire [WIDTH - 1: 0] nan_d                   = ~(A & B);
    wire [WIDTH - 1: 0] o_r                     = A | B;

    wire is_equal;
    wire is_gt;
    wire is_gt_unsign;  
    wire is_lt;
    wire is_lt_unsign;
    wire is_lt_equal;
    wire is_not_equal;

    assign is_equal     =   $signed(A) == $signed(B);
    assign is_gt        =   $signed(A) > $signed(B);
    assign is_gt_unsign =   A > B;
    assign is_lt        =   $signed(A) < $signed(B);
    assign is_lt_unsign =   A < B;
    assign is_lt_equal  =   is_lt | is_equal;
    assign is_not_equal =   !is_equal;

    always @(*) begin
        flag = 1'b0;
        case (Op_ALU)
            CHECK_EQ: flag = is_equal;

            CHECK_GT: flag = is_gt;

            CHECK_GT_UNSIGN: flag = is_gt_unsign; 

            CHECK_LT: flag = is_lt; 

            CHECK_LT_UNSIGN: flag = is_lt_unsign; 

            CHECK_LT_EQ: flag = is_lt_equal;

            CHECK_NOT_EQ: flag = is_not_equal;

            5'b1????: flag = 1'b0; 

            default: flag = 1'b0;
        endcase
    end


    always @(*) begin
        ALU_result = {WIDTH{1'bx}}; 

        case (Op_ALU)
            SRA: ALU_result = shift_right_a;

            SLL: ALU_result = shift_left;

            SRL: ALU_result = shift_right;

            ADD: ALU_result = add;

            SUB: ALU_result = sub;

            XOR: ALU_result = xo_r;

            AND: ALU_result = an_d;

            NOR: ALU_result = no_r;

            NAND: ALU_result = nan_d;

            OR: ALU_result = o_r;

            CHECK_EQ: ALU_result = {{(WIDTH-1){1'b0}},is_equal};

            CHECK_GT: ALU_result = {{(WIDTH-1){1'b0}},is_gt};

            CHECK_GT_UNSIGN: ALU_result = {{(WIDTH-1){1'b0}},is_gt_unsign}; 

            CHECK_LT: ALU_result = {{(WIDTH-1){1'b0}},is_lt}; 

            CHECK_LT_UNSIGN: ALU_result = {{(WIDTH-1){1'b0}},is_lt_unsign}; 

            CHECK_LT_EQ: ALU_result = {{(WIDTH-1){1'b0}},is_lt_equal};

            CHECK_NOT_EQ: ALU_result = {{(WIDTH-1){1'b0}},is_not_equal};


            default: ALU_result = {WIDTH{1'bx}};
        endcase
    end


endmodule