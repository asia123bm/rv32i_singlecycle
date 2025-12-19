module IMEM (
   input wire[5:0] address,
	output wire[31:0] instr
);

	reg[31:0] memory [0:63];
	initial begin 
	  $readmemb("IMEM.txt", memory);
	end
	  
	assign instr = memory[address];
endmodule
	

