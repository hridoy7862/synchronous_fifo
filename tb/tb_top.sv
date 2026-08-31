
module tb_top;

  localparam DATA_WIDTH = 8;
  localparam DEPTH      = 8;

  logic clk;

  fifo_if #(
    .DATA_WIDTH(DATA_WIDTH)
  ) vif (
    .clk(clk)
  );


  sync_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
  ) dut (
    .clk     (clk),
    .rst_n   (vif.rst_n),
    .wr_en   (vif.wr_en),
    .rd_en   (vif.rd_en),
    .wr_data (vif.wr_data),
    .rd_data (vif.rd_data),
    .full    (vif.full),
    .empty   (vif.empty)
  );


  /*
   * Clock generation: 10 ns clock period.
   */
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end


  /*
   * Reset generation.
   */
  initial begin

    vif.rst_n   = 1'b0;
    vif.wr_en   = 1'b0;
    vif.rd_en   = 1'b0;
    vif.wr_data = '0;

    repeat (3)
      @(posedge clk);

    vif.rst_n = 1'b1;

    $display("[%0t] Reset released", $time);

  end


  /*
   * Test selection.
   */
  initial begin

    string test_name;

    fifo_basic_test        basic_test;
    fifo_full_test         full_test;
    fifo_empty_test        empty_test;
    fifo_simultaneous_test simultaneous_test;

    wait(vif.rst_n === 1'b1);

    repeat (2)
      @(posedge clk);

    if (!$test$plusargs("TEST=%s", test_name))
      test_name = "BASIC";

    case (test_name)

      "BASIC": begin
        basic_test = new(vif);
        basic_test.run();
      end

      "FULL": begin
        full_test = new(vif);
        full_test.run();
      end

      "EMPTY": begin
        empty_test = new(vif);
        empty_test.run();
      end

      "SIMULTANEOUS": begin
        simultaneous_test = new(vif);
        simultaneous_test.run();
      end

      default: begin
        $fatal(1, "Unknown test name: %s", test_name);
      end

    endcase

    #50;
    $finish;

  end


  /*
   * Global simulation timeout.
   */
  initial begin
    #10000;
    $fatal(1, "Simulation timeout");
  end


  /*
   * Optional waveform generation.
   */
  initial begin
    $dumpfile("sync_fifo_tb.vcd");
    $dumpvars(0, tb_top);
  end

endmodule
