module data_memory (
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] addr,
    input  logic [31:0] wd,
    output logic [31:0] rd,
    output logic [31:0] dbg_mem_word0
);
  logic [31:0] mem[0:63];

  initial begin
    foreach (mem[i]) begin
      mem[i] = '0;
    end
  end

  always_ff @(posedge clk) begin
    if (we) begin
      mem[addr[31:2]] <= wd;
    end
  end

  assign rd = mem[addr[31:2]];
  assign dbg_mem_word0 = mem[0];
endmodule
