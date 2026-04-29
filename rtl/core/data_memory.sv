module data_memory (
    input  logic        clk,
    input  logic        we,            // Write Enable
    input  logic [31:0] addr,          // Address (must be word-aligned)
    input  logic [31:0] wd,            // Write Data
    output logic [31:0] rd,            // Read Data
    output logic [31:0] dbg_mem_word0  // Debug: expose mem[0]
);
  logic [31:0] mem[0:63];  // 64-word memory (256 bytes)

  // Initialize all memory to zero at simulation start
  initial begin
    foreach (mem[i]) begin
      mem[i] = '0;
    end
  end

  // Synchronous write
  always_ff @(posedge clk) begin
    if (we) begin
      mem[addr[31:2]] <= wd;  // Word-aligned address
    end
  end

  // Combinational read
  assign rd = mem[addr[31:2]];

  // Debug output: expose word 0 for testbench
  assign dbg_mem_word0 = mem[0];

endmodule
