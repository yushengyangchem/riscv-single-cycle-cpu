module riscv_single_cycle_cpu_tb;
  logic        clk;
  logic        rst;
  logic [31:0] dbg_pc;
  logic [31:0] dbg_x3;
  logic [31:0] dbg_x4;
  logic [31:0] dbg_x5;
  logic [31:0] dbg_x6;
  logic [31:0] dbg_mem_word0;

  riscv_single_cycle_cpu dut (
      .clk,
      .rst,
      .dbg_pc,
      .dbg_x3,
      .dbg_x4,
      .dbg_x5,
      .dbg_x6,
      .dbg_mem_word0
  );

  always #5 clk = ~clk;

  task check_final_state;
    if (dbg_x3 !== 32'd12) begin
      $display("FAIL: expected x3=12, got %0d", dbg_x3);
      $finish_and_return(1);
    end
    if (dbg_mem_word0 !== 32'd12) begin
      $display("FAIL: expected mem[0]=12, got %0d", dbg_mem_word0);
      $finish_and_return(1);
    end
    if (dbg_x5 !== 32'd12) begin
      $display("FAIL: expected x5=12, got %0d", dbg_x5);
      $finish_and_return(1);
    end
    if (dbg_x4 !== '0) begin
      $display("FAIL: branch should skip x4 write, got %0d", dbg_x4);
      $finish_and_return(1);
    end
    if (dbg_x6 !== 32'd13) begin
      $display("FAIL: expected x6=13, got %0d", dbg_x6);
      $finish_and_return(1);
    end
  endtask

  initial begin
    $dumpfile("waves/riscv_single_cycle_cpu.vcd");
    $dumpvars(0, riscv_single_cycle_cpu_tb);

    clk = '0;
    rst = 1'b1;

    repeat (2) @(posedge clk);
    rst = '0;

    repeat (10) @(posedge clk);
    #1;

    check_final_state();

    if (dbg_pc !== 32'd32) begin
      $display("FAIL: expected PC to settle at 32, got %0d", dbg_pc);
      $finish_and_return(1);
    end

    $display("PASS riscv_single_cycle_cpu_tb");
    $finish;
  end
endmodule
