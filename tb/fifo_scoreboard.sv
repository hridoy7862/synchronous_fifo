class fifo_scoreboard;

  mailbox #(fifo_transaction) mon2scb;

  bit [7:0] reference_queue[$];

  int pass_count;
  int fail_count;
  int write_count;
  int read_count;


  function new(mailbox #(fifo_transaction) mon2scb);
    this.mon2scb = mon2scb;

    pass_count  = 0;
    fail_count  = 0;
    write_count = 0;
    read_count  = 0;
  endfunction


  task check_transaction(fifo_transaction tr);

    bit [7:0] expected_data;

    /*
     * For simultaneous read and write, process the read first.
     * This matches a normal FIFO where the read uses the
     * previously stored item, while the new item is written
     * during the same clock edge.
     */
    if (tr.read_accepted) begin

      read_count++;

      if (reference_queue.size() == 0) begin

        $error(
          "[SCB] DUT accepted a read while reference FIFO was empty"
        );

        fail_count++;

      end
      else begin

        expected_data = reference_queue.pop_front();

        if (tr.actual_read_data === expected_data) begin

          $display(
            "[SCB] READ PASS: expected=%h actual=%h",
            expected_data,
            tr.actual_read_data
          );

          pass_count++;

        end
        else begin

          $error(
            "[SCB] READ FAIL: expected=%h actual=%h",
            expected_data,
            tr.actual_read_data
          );

          fail_count++;

        end

      end

    end


    if (tr.write_accepted) begin

      reference_queue.push_back(tr.data);
      write_count++;

      $display(
        "[SCB] WRITE recorded: data=%h reference_depth=%0d",
        tr.data,
        reference_queue.size()
      );

    end


    /*
     * Check empty status against reference queue.
     */
    if (tr.empty !== (reference_queue.size() == 0)) begin

      $error(
        "[SCB] EMPTY mismatch: DUT empty=%0b reference_depth=%0d",
        tr.empty,
        reference_queue.size()
      );

      fail_count++;

    end

  endtask


  task run();

    fifo_transaction tr;

    forever begin
      mon2scb.get(tr);
      check_transaction(tr);
    end

  endtask


  function void report();

    $display("\n========================================");
    $display("          FIFO SCOREBOARD REPORT");
    $display("========================================");
    $display("Accepted writes : %0d", write_count);
    $display("Accepted reads  : %0d", read_count);
    $display("Passed checks   : %0d", pass_count);
    $display("Failed checks   : %0d", fail_count);
    $display("Reference depth : %0d", reference_queue.size());

    if (fail_count == 0)
      $display("FINAL RESULT    : TEST PASSED");
    else
      $display("FINAL RESULT    : TEST FAILED");

    $display("========================================\n");

  endfunction

endclass
