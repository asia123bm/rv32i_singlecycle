module PC (
    input  wire        clk,
    input  wire        reset,
    input  wire        enable,
    output reg [31:0]  pc
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'd0;
        else if (enable)
            pc <= pc + 32'd4;
    end

endmodule
