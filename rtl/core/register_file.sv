module register_file (
    input  logic        clk,
    input  logic        we,
    input  logic [ 4:0] rs1,
    input  logic [ 4:0] rs2,
    input  logic [ 4:0] rd,
    input  logic [31:0] wd,
    output logic [31:0] rd1,
    output logic [31:0] rd2,
    output logic [31:0] dbg_x3,
    output logic [31:0] dbg_x4,
    output logic [31:0] dbg_x5,
    output logic [31:0] dbg_x6
);
  logic [31:0] regs[0:31];

  initial begin
    foreach (regs[i]) begin
      regs[i] = '0;
    end
  end

  assign rd1 = (rs1 == '0) ? '0 : regs[rs1];
  assign rd2 = (rs2 == '0) ? '0 : regs[rs2];

  assign dbg_x3 = regs[3];
  assign dbg_x4 = regs[4];
  assign dbg_x5 = regs[5];
  assign dbg_x6 = regs[6];

  always_ff @(posedge clk) begin
    if (we && (rd != '0)) begin
      regs[rd] <= wd;
    end
    regs[0] <= '0;
  end
endmodule
