module mux2to1(
    input wire [31:0] I0,
    input wire [31:0] I1,
    input wire Sel,
    output wire [31:0] Y
);

    assign Y = Sel ? I0 : I1;

endmodule