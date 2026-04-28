module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_write,
    output logic       branch,
    output logic       jump,
    output logic [1:0] result_src,
    output logic [2:0] alu_control,
    output logic [2:0] imm_type
);
  localparam logic [1:0] RES_ALU = 2'd0;
  localparam logic [1:0] RES_MEM = 2'd1;
  localparam logic [1:0] RES_PC4 = 2'd2;

  localparam logic [2:0] ALU_ADD = 3'd0;
  localparam logic [2:0] ALU_SUB = 3'd1;

  localparam logic [2:0] IMM_I = 3'd0;
  localparam logic [2:0] IMM_S = 3'd1;
  localparam logic [2:0] IMM_B = 3'd2;
  localparam logic [2:0] IMM_J = 3'd3;

  always_comb begin
    reg_write   = '0;
    alu_src     = '0;
    mem_write   = '0;
    branch      = '0;
    jump        = '0;
    result_src  = RES_ALU;
    alu_control = ALU_ADD;
    imm_type    = IMM_I;

    case (opcode)
      7'b0010011: begin  // addi rd, rs1, imm
        reg_write   = 1'b1;
        alu_src     = 1'b1;
        result_src  = RES_ALU;
        alu_control = ALU_ADD;
        imm_type    = IMM_I;
      end
      7'b0110011: begin  // add rd, rs1, rs2 & sub rd, rs1, rs2
        reg_write  = 1'b1;
        result_src = RES_ALU;
        imm_type   = IMM_I;
        if ({funct7, funct3} == 10'b0100000_000) begin
          alu_control = ALU_SUB;
        end else begin
          alu_control = ALU_ADD;
        end
      end
      7'b0000011: begin  // lw rd, imm(rs1)
        reg_write   = 1'b1;
        alu_src     = 1'b1;
        result_src  = RES_MEM;
        alu_control = ALU_ADD;
        imm_type    = IMM_I;
      end
      7'b0100011: begin  // sw rs2, imm(rs1)
        alu_src     = 1'b1;
        mem_write   = 1'b1;
        alu_control = ALU_ADD;
        imm_type    = IMM_S;
      end
      7'b1100011: begin  // beq rs1, rs2, label
        branch      = 1'b1;
        alu_control = ALU_SUB;
        imm_type    = IMM_B;
      end
      7'b1101111: begin  // jal
        reg_write  = 1'b1;
        jump       = 1'b1;
        result_src = RES_PC4;
        imm_type   = IMM_J;
      end
      default: begin
      end
    endcase
  end
endmodule
