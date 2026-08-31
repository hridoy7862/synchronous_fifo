class fifo_full_test extends fifo_base_test;

  function new(virtual fifo_if vif);
    super.new(vif);
  endfunction


  task run();

    $display("\n========================================");
    $display("              FIFO FULL TEST");
    $display("========================================");

    super.run();

    for (int i = 0; i < 8; i++) begin
      env.gen.send_write(8'h10 + i);
    end

    env.wait_clocks(2);

    if (vif.full === 1'b1)
      $display("[TEST] PASS: FIFO full asserted after 8 writes");
    else
      $error("[TEST] FAIL: FIFO full did not assert");

    /*
     * Attempt an extra write.
     * The DUT should reject it because full = 1.
     */
    env.gen.send_write(8'hFF);

    env.wait_clocks(3);

    env.report();

  endtask

endclass
