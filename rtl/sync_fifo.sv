module sync_fifo #( 
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8
)(
    input  logic                  clk,
    input  logic                  rst_n,    // Active-low reset
    input  logic                  wr_en,    // Write enable
    input  logic                  rd_en,    // Read enable
    input  logic [DATA_WIDTH-1:0] wr_data,  // Write data
    output logic [DATA_WIDTH-1:0] rd_data,  // Read data
    output logic                  full,     // FIFO full flag
    output logic                  empty     // FIFO empty flag
);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [$clog2(DEPTH):0] wr_ptr;
    logic [$clog2(DEPTH):0] rd_ptr;

    // Full: same lower bits, different MSB
    // Empty: pointers are completely equal
    assign full  = (wr_ptr[2:0] == rd_ptr[2:0]) && (wr_ptr[3] != rd_ptr[3]);
    assign empty = (wr_ptr == rd_ptr);

    // Write logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr[2:0]] <= wr_data;
            wr_ptr           <= wr_ptr + 1;
        end
    end

    // Read logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr  <= 0;
            rd_data <= 0;
        end else if (rd_en && !empty) begin
            rd_data <= mem[rd_ptr[2:0]];
            rd_ptr  <= rd_ptr + 1;
        end
    end

endmodule
