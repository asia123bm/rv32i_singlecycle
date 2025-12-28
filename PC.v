// module PC (
//     input  wire        clk,
//     input  wire        reset,
//     input  wire        enable,
//     output reg [31:0]  pc
// );

//     always @(posedge clk or posedge reset) begin
//         if (reset)
//             pc <= 32'd0;
//         else if (enable)
//             pc <= pc + 32'd4;
//     end

// endmodule


//---------------------PC just a Latch not counter--------------

module PC (
    input wire          clk,
    input wire          reset,
    input wire [31:0]   pc_in,
    output reg [31:0]   pc_out
);


    always @(posedge clk) begin
        if(reset)
            pc_out <= 32'b0;
        else
            pc_out <= pc_in;
    end

endmodule