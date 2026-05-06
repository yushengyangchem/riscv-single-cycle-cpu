module riscv_single_cycle_cpu (
    input logic clk,
    input logic rst,

    output logic [31:0] dbg_pc,
    output logic [31:0] dbg_x3,
    output logic [31:0] dbg_x4,
    output logic [31:0] dbg_x5,
    output logic [31:0] dbg_x6,
    output logic [31:0] dbg_mem_word0
);
  localparam logic [1:0] RES_ALU = 2'd0;
  localparam logic [1:0] RES_MEM = 2'd1;
  localparam logic [1:0] RES_PC4 = 2'd2;

  // Program counter
  logic [31:0] pc;
  logic [31:0] next_pc;
  logic [31:0] pc_plus_4;
  logic [31:0] pc_plus_imm;

  // Instruction fields
  logic [31:0] instruction;
  logic [ 4:0] rs1;
  logic [ 4:0] rs2;
  logic [ 4:0] rd;
  logic [ 6:0] opcode;
  logic [ 2:0] funct3;
  logic [ 6:0] funct7;

  // Datapath signals
  logic [31:0] reg_rs1_data;
  logic [31:0] reg_rs2_data;
  logic [31:0] imm;
  logic [31:0] alu_b;
  logic [31:0] alu_result;
  logic [31:0] mem_read_data;
  logic [31:0] writeback_data;

  // Control signals
  logic        reg_write;
  logic        alu_src;
  logic        mem_write;
  logic        branch;
  logic        jump;
  logic [ 1:0] result_src;
  logic [ 2:0] alu_control;
  logic [ 2:0] imm_type;
  logic        alu_zero;
  logic        branch_taken;

  assign opcode       = instruction[6:0];
  assign rd           = instruction[11:7];
  assign funct3       = instruction[14:12];
  assign rs1          = instruction[19:15];
  assign rs2          = instruction[24:20];
  assign funct7       = instruction[31:25];

  assign pc_plus_4    = pc + 32'd4;
  assign pc_plus_imm  = pc + imm;

  assign alu_b        = alu_src ? imm : reg_rs2_data;
  assign branch_taken = branch && (funct3 == 3'b000) && alu_zero;

  always_comb begin
    if (jump || branch_taken) begin
      next_pc = pc_plus_imm;
    end else begin
      next_pc = pc_plus_4;
    end
  end

  always_comb begin
    case (result_src)
      RES_ALU: writeback_data = alu_result;
      RES_MEM: writeback_data = mem_read_data;
      RES_PC4: writeback_data = pc_plus_4;
      default: writeback_data = alu_result;
    endcase
  end

  assign dbg_pc = pc;

  program_counter u_pc (
      .clk    (clk),
      .rst    (rst),
      .next_pc(next_pc),
      .pc     (pc)
  );

  instruction_memory u_imem (
      .addr       (pc),
      .instruction(instruction)
  );

  control_unit u_ctrl (
      .opcode     (opcode),
      .funct3     (funct3),
      .funct7     (funct7),
      .reg_write  (reg_write),
      .alu_src    (alu_src),
      .mem_write  (mem_write),
      .branch     (branch),
      .jump       (jump),
      .result_src (result_src),
      .alu_control(alu_control),
      .imm_type   (imm_type)
  );

  register_file u_regfile (
      .clk   (clk),
      .we    (reg_write),
      .rs1   (rs1),
      .rs2   (rs2),
      .rd    (rd),
      .wd    (writeback_data),
      .rd1   (reg_rs1_data),
      .rd2   (reg_rs2_data),
      .dbg_x3(dbg_x3),
      .dbg_x4(dbg_x4),
      .dbg_x5(dbg_x5),
      .dbg_x6(dbg_x6)
  );

  immediate_gen u_imm (
      .instruction(instruction),
      .imm_type   (imm_type),
      .imm        (imm)
  );

  alu u_alu (
      .a          (reg_rs1_data),
      .b          (alu_b),
      .alu_control(alu_control),
      .result     (alu_result),
      .zero       (alu_zero)
  );

  data_memory u_dmem (
      .clk          (clk),
      .we           (mem_write),
      .addr         (alu_result),
      .wd           (reg_rs2_data),
      .rd           (mem_read_data),
      .dbg_mem_word0(dbg_mem_word0)
  );
endmodule
