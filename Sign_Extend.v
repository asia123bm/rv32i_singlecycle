module Sign_Extend (
    input [31:0] IR,
    input [2:0] SE_Control,
    output reg [31:0] imm
);
    always @(*) begin
        case (SE_Control) 
            3'd0: imm[31:0] = {{20{IR[31]}}, IR[31:20]};                          // Lenh I
            3'd1: imm[31:0] = {{20{IR[31]}}, IR[31:25], IR[11:7]};                // Lenh S
            3'd2: imm[31:0] = {{20{IR[31]}}, IR[7], IR[30:25], IR[11:8], 1'b0};   // Lenh B 
            3'd3: imm[31:0] = {IR[31:12], 12'b0};                               // lenh U
            3'd4: imm[31:0] = {{12{IR[31]}}, IR[19:12], IR[20], IR[30:21], 1'b0};   // Lenh J
            default: imm = 32'd0;
        endcase
    end

endmodule
