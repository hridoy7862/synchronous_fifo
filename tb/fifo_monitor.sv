class fifo_monitor;

  virtual fifo_if vif;

  mailbox #(fifo_transaction) mon2scb;

  function new(
    virtual fifo_if vif,
    mailbox #(fifo_transaction) mon2scb
  );
    this.vif     = vif;
    this.mon2scb = mon2scb;
  endfunction


  task run();

    fifo_transaction tr;

    bit write_accepted;
    bit read_accepted;
    bit [7:0] sampled_write_data;

    forever begin

      @(posedge vif.clk);

      if (!vif.rst_n)
        continue;

      /*
       * Capture the request and pre-clock status.
       * These conditions determine whether the DUT accepts
       * the operation at this positive clock edge.
       */
      write_accepted    = vif.wr_en && !vif.full;
      read_accepted     = vif.rd_en && !vif.empty;
      sampled_write_data = vif.wr_data;

      if (vif.wr_en || vif.rd_en) begin

        /*
         * Wait until nonblocking assignments inside the DUT
         * update rd_data and the FIFO pointers.
         */
        #1step;

        tr = new();

        tr.write_accepted  = write_accepted;
        tr.read_accepted   = read_accepted;
        tr.data            = sampled_write_data;
        tr.actual_read_data = vif.rd_data;
        tr.full            = vif.full;
        tr.empty           = vif.empty;

        if (vif.wr_en && vif.rd_en)
          tr.operation = FIFO_WRITE_READ;
        else if (vif.wr_en)
          tr.operation = FIFO_WRITE;
        else
          tr.operation = FIFO_READ;

        tr.display("MONITOR");

        mon2scb.put(tr);

      end

    end

  endtask

endclass
