class fifo_driver;

  virtual fifo_if vif;

  mailbox #(fifo_transaction) gen2drv;

  function new(
    virtual fifo_if vif,
    mailbox #(fifo_transaction) gen2drv
  );
    this.vif     = vif;
    this.gen2drv = gen2drv;
  endfunction


  task initialize();
    vif.wr_en   <= 1'b0;
    vif.rd_en   <= 1'b0;
    vif.wr_data <= '0;
  endtask


  task drive_write(fifo_transaction tr);

    @(negedge vif.clk);

    vif.wr_en   <= 1'b1;
    vif.rd_en   <= 1'b0;
    vif.wr_data <= tr.data;

    @(negedge vif.clk);

    vif.wr_en   <= 1'b0;
    vif.wr_data <= '0;

  endtask


  task drive_read();

    @(negedge vif.clk);

    vif.wr_en <= 1'b0;
    vif.rd_en <= 1'b1;

    @(negedge vif.clk);

    vif.rd_en <= 1'b0;

  endtask


  task drive_write_read(fifo_transaction tr);

    @(negedge vif.clk);

    vif.wr_en   <= 1'b1;
    vif.rd_en   <= 1'b1;
    vif.wr_data <= tr.data;

    @(negedge vif.clk);

    vif.wr_en   <= 1'b0;
    vif.rd_en   <= 1'b0;
    vif.wr_data <= '0;

  endtask


  task drive_idle();

    @(negedge vif.clk);

    vif.wr_en <= 1'b0;
    vif.rd_en <= 1'b0;

  endtask


  task run();

    fifo_transaction tr;

    forever begin

      gen2drv.get(tr);

      case (tr.operation)

        FIFO_WRITE: begin
          drive_write(tr);
        end

        FIFO_READ: begin
          drive_read();
        end

        FIFO_WRITE_READ: begin
          drive_write_read(tr);
        end

        FIFO_IDLE: begin
          drive_idle();
        end

        default: begin
          $error("[DRIVER] Unknown FIFO operation");
        end

      endcase

    end

  endtask

endclass
