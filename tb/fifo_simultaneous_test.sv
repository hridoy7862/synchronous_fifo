class fifo_simultaneous_test extends fifo_base_test;

  function new(virtual fifo_if vif);
    super.new(vif);
  endfunction


  task run();

    $display("\n========================================");
    $display("       FIFO SIMULTANEOUS READ/WRITE");
    $display("========================================");

    super.run();

    /*
     * First put data into FIFO so that the simultaneous
     * read operation is valid.
     */
    env.gen.send_write(8'hA1);
    env.gen.send_write(8'hB2);

    /*
     * Read A1 and write C3 during the same clock.
     */
    env.gen.send_write_read(8'hC3);

    /*
     * Remaining expected sequence is B2 followed by C3.
     */
    env.gen.send_read();
    env.gen.send_read();

    env.wait_clocks(5);

    env.report();

  endtask

endclass
