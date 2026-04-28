module instruction_memory (
    input  logic [31:0] addr,
    output logic [31:0] instruction
);
  logic [31:0] rom[0:63];

  initial begin
    foreach (rom[i]) begin
      rom[i] = 32'h00000013;
    end

    rom[0] = 32'h00500093;  // addi x1, x0, 5
    rom[1] = 32'h00700113;  // addi x2, x0, 7
    rom[2] = 32'h002081b3;  // add  x3, x1, x2
    rom[3] = 32'h00302023;  // sw   x3, 0(x0)
    rom[4] = 32'h00002283;  // lw   x5, 0(x0)
    rom[5] = 32'h00518463;  // beq  x3, x5, +8
    rom[6] = 32'h06300213;  // addi x4, x0, 99
    rom[7] = 32'h00118313;  // addi x6, x3, 1
    rom[8] = 32'h0000006f;  // jal  x0, 0
  end

  assign instruction = rom[addr[31:2]];
endmodule
