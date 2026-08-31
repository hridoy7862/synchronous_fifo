class fifo_environment;

  virtual fifo_if vif;

  fifo_generator  gen;
  fifo_driver     drv;
  fifo_monitor    mon;
  fifo_scoreboard scb;

  mailbox #(fifo_transaction) gen2drv;
  mailbox #(fifo_transaction) mon2scb;


  function new(virtual fifo_if vif);

    this.vif = vif;

    gen2drv = new();
    mon2scb = new();

    gen = new(gen2drv);
    drv = new(vif, gen2drv);
    mon = new(vif, mon2scb);
    scb = new(mon2scb);

  endfunction


  task start();

    drv.initialize();

    fork
      drv.run();
      mon.run();
      scb.run();
    join_none

  endtask


  task wait_clocks(int number_of_clocks);

    repeat (number_of_clocks)
      @(posedge vif.clk);

  endtask


  function void report();
    scb.report();
  endfunction

endclass
