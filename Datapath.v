module Datapath(
    input   wire          clk,
    input   wire          reset,
    input   wire          Jump,
    input   wire          RE_DMEM,//DMEM khong co port nay
    input   wire          WE_DMEM,
    input   wire          Branch,
    input   wire          WE_RF,
    input   wire    [2:0] Mode_DMEM,
    input   wire    [2:0] Select_WD_RF,
    input   wire    [4:0] Op_ALU,
    input   wire          Select_PC_RS1,
    input   wire          Select_SrcB_ALU,
    input   wire    [2:0] SignExt_Control,
    output  wire    [6:0] op,
    output  wire    [2:0] funct3,
    output  wire    [6:0] funct7
);
    wire    [31:0] loaded_pc_w;
    wire    [31:0] pc_plus4_w;
    wire     [31:0] next_pc_r;
    wire    [31:0] PC_w;
    wire           flag;
    wire           select_next_pc_w;

    assign select_next_pc_w = (flag & Branch) | Jump;

    mux2to1 select_next_pc_mux (
        .I0(loaded_pc_w),
        .I1(pc_plus4_w),
        .Sel(select_next_pc_w),
        .Y(next_pc_r)
    );

    PC PC_latch (
        .clk(clk),
        .reset(reset),
        .pc_in(next_pc_r),
        .pc_out(PC_w)
    );

    FA_32bit pc_plus4_unit (
        .I0(PC_w),
        .I1(32'd4),
        .Cin(32'b0),
        .Sum(pc_plus4_w),
        .Cout()
    );

    wire    [5:0]   imem_address_w;
    wire    [31:0]  instruction_w;

    assign imem_address_w = PC_w[7:2];

    IMEM imem_unit (
        .address(imem_address_w),
        .instr(instruction_w)
    );


    assign op = instruction_w[6:0];
    assign funct3 = instruction_w[14:12];
    assign funct7 = instruction_w[31:25];

    wire    [4:0] RR1_w;
    wire    [4:0] RR2_w;
    wire    [4:0] WA_w;
    wire    [31:0] write_back_data_w;
    wire    [31:0] RD1D_w;
    wire    [31:0] RD2D_W;


    reg_files reg_file_unit (
        .clk(clk),
        .we(WE_RF),
        .ra1(RR1_w),
        .ra2(RR2_W),
        .wa(WA_w),
        .wd(write_back_data_w),
        .rd1(RD1D_w),
        .rd2(RD2D_W)
    );

    
    wire    [31:0] immExtD;

    Sign_Extend Sign_Extend_unit (
        .IR(instruction_w),
        .SE_Control(SignExt_Control),
        .imm(immExtD)
    );


    wire    [31:0] ALU_src_B_w;

    mux2to1 selec_srcB_mux (
        .I0(immExtD),
        .I1(RD2D_W),
        .Sel(Select_SrcB_ALU),
        .Y(ALU_src_B_w)
    );


    wire    [31:0] ALU_result_w;

    ALU ALU_unit (
        .A(RD1D_w),
        .B(ALU_src_B_w),
        .Op_ALU(Op_ALU),
        .ALU_result(ALU_result_w),
        .flag(flag)
    );


    wire    [31:0] PC_RD1;

    mux2to1 Select_PC_RS1_unit (
        .I0(RD1D_wPC),
        .I1(RD1D_w),
        .Sel(Select_PC_RS1),
        .Y(PC_RD1)
    );

    wire    [31:0] PC_Add_Imm;

    FA_32bit Add_pc_and_imm_unit (
        .I0(PC_RD1),
        .I1(immExtD),
        .Cin(32'b0),
        .Sum(PC_Add_Imm),
        .Cout()
    );

    wire    [31:0] Read_Data_M_w;

    DMEM DMEM_unit (
        .clk(clk),
        .mem_write(WE_DMEM),
        .addr(ALU_result_w),
        .data_in(RD2D_W),
        .mode(Mode_DMEM),
        .data_out(Read_Data_M_w)
    );

    
    mux5to1 select_wb_data_unit (
        .I0(ALU_result_w),
        .I1(Read_Data_M_w),
        .I2(pc_plus4_w),
        .I3(immExtD),
        .I4(PC_Add_Imm),
        .Sel(Select_WD_RF),
        .Y(write_back_data_w)
    );





endmodule