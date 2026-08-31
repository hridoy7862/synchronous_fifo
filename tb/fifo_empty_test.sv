class fifo_empty_test extends fifo_base_test;

  function new(virtual fifo_if vif);
    super.new(vif);
  endfunction


  task run();

    bit [7:0] old_read_data;

    $display("\n========================================");
    $display("             FIFO EMPTY TEST");
    $display("========================================");

    super.run();

    env.wait_clocks(1);

    if (vif.empty === 1'b1)
      $display("[TEST] PASS: FIFO empty asserted after reset");
    else
      $error("[TEST] FAIL: FIFO empty was not asserted");

    old_read_data = vif.rd_data;

    /*
     * Attempt to read while empty.
     */
    env.gen.send_read();

    env.wait_clocks(3);

    if (vif.empty === 1'b1)
      $display("[TEST] PASS: FIFO remains empty after illegal read");
    else
      $error("[TEST] FAIL: Empty changed after rejected read");

    if (vif.rd_data === old_read_data)
      $display("[TEST] PASS: rd_data unchanged during empty read");
    else
      $error("[TEST] FAIL: rd_data changed during empty read");

    env.report();

  endtask

endclass
