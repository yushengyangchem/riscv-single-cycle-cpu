module immediate_gen (
    input  logic [31:0] instruction,
    input  logic [ 2:0] imm_type,
    output logic [31:0] imm
);
  localparam logic [2:0] IMM_I = '0;
  localparam logic [2:0] IMM_S = 3'd1;
  localparam logic [2:0] IMM_B = 3'd2;
  localparam logic [2:0] IMM_J = 3'd3;

  logic [31:0] imm_i, imm_s, imm_b, imm_j;

  assign imm_i = {{20{instruction[31]}}, instruction[31:20]};
  assign imm_s = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
  assign imm_b = {
    {19{instruction[31]}},
    instruction[31],
    instruction[7],
    instruction[30:25],
    instruction[11:8],
    1'b0
  };
  assign imm_j = {
    {11{instruction[31]}},
    instruction[31],
    instruction[19:12],
    instruction[20],
    instruction[30:21],
    1'b0
  };

  always_comb begin
    case (imm_type)
      IMM_I:   imm = imm_i;
      IMM_S:   imm = imm_s;
      IMM_B:   imm = imm_b;
      IMM_J:   imm = imm_j;
      default: imm = '0;
    endcase
  end
endmodule
