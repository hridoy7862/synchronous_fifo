class fifo_base_test;

  virtual fifo_if vif;
  fifo_environment env;

  function new(virtual fifo_if vif);
    this.vif = vif;
    env = new(vif);
  endfunction


  virtual task run();

    $display("\n========================================");
    $display("              BASE TEST");
    $display("========================================");

    env.start();

  endtask

endclass
