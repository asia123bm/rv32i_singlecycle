module DMEM #(
    parameter ADDR_WIDTH = 12,          
    parameter MEM_SIZE = 1024
)(
    input wire clk,
    input wire mem_write,                
    input wire [ADDR_WIDTH-1:0] addr,    
    input wire [31:0] data_in,          
    input wire [2:0] mode,               
    output reg [31:0] data_out           

    reg [7:0] mem [0:MEM_SIZE-1];

    localparam BYTE = 3'b000;
    localparam HD = 3'b001;
    localparam WORD = 3'b010;
    localparam BU = 3'b100;
    localparam HU = 3'b101;

    always @(posedge clk) begin
        if (mem_write) begin
            case (mode[1:0]) 
                2'b00: begin 
                    mem[addr] <= data_in[7:0];
                end
                2'b01: begin 
                    mem[addr]   <= data_in[7:0];
                    mem[addr+1] <= data_in[15:8];
                end
                2'b10: begin 
                    mem[addr]   <= data_in[7:0];
                    mem[addr+1] <= data_in[15:8];
                    mem[addr+2] <= data_in[23:16];
                    mem[addr+3] <= data_in[31:24];
                end
            endcase
        end
    end

    always @(*) begin
        case (mode)
            BYTE: data_out = {{24{mem[addr][7]}}, mem[addr]};                        
            HD: data_out = {{16{mem[addr+1][7]}}, mem[addr+1], mem[addr]};         
            WORD: data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};      
            BU: data_out = {24'b0, mem[addr]};                                   
            HU: data_out = {16'b0, mem[addr+1], mem[addr]};                      
            default: data_out = 32'h0;
        endcase
    end

endmodule
