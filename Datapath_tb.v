module Datapath_tb;

    reg           clk;
    reg           reset;
    reg           Jump;
    reg           RE_DMEM;//DMEM khong co port nay
    reg           WE_DMEM;
    reg           Branch;
    reg           WE_RF;
    reg     [2:0] Mode_DMEM;
    reg     [2:0] Select_WD_RF;
    reg     [4:0] Op_ALU;
    reg           Select_PC_RS1;
    reg           Select_SrcB_ALU;
    reg     [2:0] SignExt_Control;
    wire    [6:0] op;
    wire    [2:0] funct3;
    wire    [6:0] funct7;


    Datapath datapath_ut (
        .clk(clk),
        .reset(reset),
        .Jump(Jump),
        .RE_DMEM(RE_DMEM),//DMEM khong co port nay
        .WE_DMEM(WE_DMEM),
        .Branch(Branch),
        .WE_RF(WE_RF),
        .Mode_DMEM(Mode_DMEM),
        .Select_WD_RF(Select_WD_RF),
        .Op_ALU(Op_ALU),
        .Select_PC_RS1(Select_PC_RS1),
        .Select_SrcB_ALU(Select_SrcB_ALU),
        .SignExt_Control(SignExt_Control),
        .op(op),
        .funct3(funct3),
        .funct7(funct7)
    );


    always #5 clk = ~clk;

    initial begin
        clk = 0;
        #10
//--------------- add x10, x11, x12 (R-type)//     ---------------
        WE_DMEM = 0;
        RE_MEM = 0;
        Jump = 0;
        Branch = 0;
        WE_RF = 1;
        Mode_DMEM = 3'b1;
        Select_WD_RF = 0;
        Op_ALU = 5'b11010;
        Select_PC_RS1 = 3'd0;
        Select_SrcB_ALU = 0;
        SignExt_Control = 3'd0;
        #10; 
//---------------  addi x5, x0, 10 (I-type//      ---------------
        WE_DMEM = 0;
        RE_MEM = 0;
        Jump = 0;
        Branch = 0;
        WE_RF = 1;
        Mode_DMEM = 3'b1;
        Select_WD_RF = 0;
        Op_ALU = 5'b11010;
        Select_PC_RS1 = 3'd0;
        Select_SrcB_ALU = 1;
        SignExt_Control = 3'd0;
        #10;
//---------------  or x6, x10, x11 (R-type)          ---------------
        WE_DMEM = 0;
        RE_MEM = 0;
        Jump = 0;
        Branch = 0;
        WE_RF = 1;
        Mode_DMEM = 3'b1;
        Select_WD_RF = 0;
        Op_ALU = 5'b10000;
        Select_PC_RS1 = 3'd0;
        Select_SrcB_ALU = 0;
        SignExt_Control = 3'd0;
        #10;
//---------------  sll x7, x12, x13 (R-type)          ---------------
        WE_DMEM = 0;
        RE_MEM = 0;
        Jump = 0;
        Branch = 0;
        WE_RF = 1;
        Mode_DMEM = 3'b1;
        Select_WD_RF = 0;
        Op_ALU = 5'b11000;
        Select_PC_RS1 = 3'd0;
        Select_SrcB_ALU = 0;
        SignExt_Control = 3'd0;
        #10;
//---------------  lw x10, 4(x2) (I-type)             ---------------
        WE_DMEM = 0;
        RE_MEM = 1;
        Jump = 0;
        Branch = 0;
        WE_RF = 1;
        Mode_DMEM = 3'b010;
        Select_WD_RF = 3'd1;
        Op_ALU = 5'b11000;
        Select_PC_RS1 = 0;
        Select_SrcB_ALU = 0;
        SignExt_Control = 3'd0;
        #10;
//---------------  sw x11, 8(x2) (S-type)             ---------------
        WE_DMEM = 0;
        RE_MEM = 0;
        Jump = 0;
        Branch = 0;
        WE_RF = 1;
        Mode_DMEM = 3'b010;
        Select_WD_RF = 3'd0;
        Op_ALU = 5'b11010;
        Select_PC_RS1 = 0;
        Select_SrcB_ALU = 1;
        SignExt_Control = 3'd1;
        #10;
//---------------  slt x5, x10, x11 (R-type)          ---------------
        WE_DMEM = 0;
        RE_MEM = 0;
        Jump = 0;
        Branch = 0;
        WE_RF = 1;
        Mode_DMEM = 3'b010;
        Select_WD_RF = 3'd1;
        Op_ALU = 5'b00011;
        Select_PC_RS1 = 0;
        Select_SrcB_ALU = 0;
        SignExt_Control = 3'd1;
        #10;
//---------------  lui x10, 0x12345 (U-type)          ---------------
        WE_DMEM = 1;
        RE_MEM = 0;
        Jump = 0;
        Branch = 0;
        WE_RF = 0;
        Mode_DMEM = 3'b010;
        Select_WD_RF = 3'd5;
        Op_ALU = 5'b00011;
        Select_PC_RS1 = 0;
        Select_SrcB_ALU = 0;
        SignExt_Control = 3'd0;
        #10;
//---------------  beq x10, x11, 12 (B-type)          ---------------
        WE_DMEM = 0;
        RE_MEM = 0;
        Jump = 0;
        Branch = 1;
        WE_RF = 0;
        Mode_DMEM = 3'b010;
        Select_WD_RF = 3'd4;
        Op_ALU = 5'b00000;
        Select_PC_RS1 = 1;
        Select_SrcB_ALU = 0;
        SignExt_Control = 3'd2;
        #10;
    end
    

endmodule