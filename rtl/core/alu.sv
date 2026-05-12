module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [ 2:0] alu_control,
    output logic [31:0] result,
    output logic        zero
);
  localparam logic [2:0] ALU_ADD = 3'd0;
  localparam logic [2:0] ALU_SUB = 3'd1;
  localparam logic [2:0] ALU_AND = 3'd2;
  localparam logic [2:0] ALU_OR = 3'd3;

  // 1. Main ALU Datapath (Calculates the 32-bit result)
  always_comb begin
    case (alu_control)
      ALU_ADD: result = a + b;
      ALU_SUB: result = a - b;
      ALU_AND: result = a & b;
      ALU_OR:  result = a | b;
      default: result = '0;
    endcase
  end

  // 2. Specific Zero Calculation (The "Fast Path")
  always_comb begin
    case (alu_control)
      // FAST PATH: Instead of waiting for subtraction, just check if they are equal!
      ALU_SUB: zero = (a == b);

      // For other operations, calculate zero directly from the math
      ALU_ADD: zero = ((a + b) == '0);
      ALU_AND: zero = ((a & b) == '0);
      ALU_OR:  zero = ((a | b) == '0);
      default: zero = 1'b0;
    endcase
  end

endmodule
