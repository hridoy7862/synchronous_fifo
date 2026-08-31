class fifo_generator;

  mailbox #(fifo_transaction) gen2drv;

  function new(mailbox #(fifo_transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction


  task send_write(bit [7:0] data);
    fifo_transaction tr;

    tr = new();
    tr.operation = FIFO_WRITE;
    tr.data      = data;

    tr.display("GENERATOR");
    gen2drv.put(tr);
  endtask


  task send_read();
    fifo_transaction tr;

    tr = new();
    tr.operation = FIFO_READ;

    tr.display("GENERATOR");
    gen2drv.put(tr);
  endtask


  task send_write_read(bit [7:0] data);
    fifo_transaction tr;

    tr = new();
    tr.operation = FIFO_WRITE_READ;
    tr.data      = data;

    tr.display("GENERATOR");
    gen2drv.put(tr);
  endtask


  task send_idle();
    fifo_transaction tr;

    tr = new();
    tr.operation = FIFO_IDLE;

    gen2drv.put(tr);
  endtask

endclass
