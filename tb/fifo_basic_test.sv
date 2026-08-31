class fifo_basic_test extends fifo_base_test;

  function new(virtual fifo_if vif);
    super.new(vif);
  endfunction


  task run();

    $display("\n========================================");
    $display("          FIFO BASIC WRITE/READ TEST");
    $display("========================================");

    super.run();

    env.gen.send_write(8'h11);
    env.gen.send_write(8'h22);
    env.gen.send_write(8'h33);
    env.gen.send_write(8'h44);

    env.gen.send_read();
    env.gen.send_read();
    env.gen.send_read();
    env.gen.send_read();

    env.wait_clocks(5);

    env.report();

  endtask

endclass
