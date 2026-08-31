typedef enum {
  FIFO_WRITE,
  FIFO_READ,
  FIFO_WRITE_READ,
  FIFO_IDLE
} fifo_operation_t;


class fifo_transaction;

  rand bit [7:0] data;
  fifo_operation_t operation;

  bit write_accepted;
  bit read_accepted;

  bit [7:0] actual_read_data;

  bit full;
  bit empty;

  function void display(string component);
    $display(
      "[%0t] [%s] operation=%s write_data=%h read_data=%h full=%0b empty=%0b",
      $time,
      component,
      operation.name(),
      data,
      actual_read_data,
      full,
      empty
    );
  endfunction

endclass
