module FA_32bit(
    input wire [31:0] I0,
    input wire [31:0] I1,
    input wire Cin,
    output wire [31:0] Sum,
    output wire Cout
);

    assign {Cout, Sum} = I0 + I1 + Cin;

endmodule