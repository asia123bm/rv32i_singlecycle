module mux5to1(
    input wire [31:0] I0, // ALUResult
    input wire [31:0] I1, // ReadDataM
    input wire [31:0] I2, // PC_Plus4
    input wire [31:0] I3, // ImmExtD
    input wire [31:0] I4, // PC_Add_Imm
    input wire [2:0] Sel,
    output reg [31:0] Y
);

    always @(*) begin
        case (Sel)
            3'b000: Y = I0;
            3'b001: Y = I1;
            3'b010: Y = I2;
            3'b011: Y = I3;
            3'b100: Y = I4;
            default: Y = 32'b0;
        endcase
    end

endmodule