module agray_sync_fifo #(
    parameters (
        parameter integer fifo_depth = 16,
        parameter integer data_width = 8
    )
) (
    input wire wr_clk,
    input wire rd_clk,
    input wire wr_reset_n,
    input wire rd_reset_n,
    input reg [data_width - 1 : 0] data_in,
    input reg wr_en,
    input reg rd_en,
    output reg [data_width - 1 : 0] data_out,
    output wire empty,
    output wire full

);
    reg [data_width - 1 : 0] mem [ 0 : fifo_depth - 1];
    reg [$clog2(fifo_depth) : 0] wr_ptr, rd_ptr ,                           //binary pointers
                                 wr_ptr_gray, rd_ptr_gray ,                 //gray pointers
                                 wr_ptr_gray_sync1, wr_ptr_gray_sync2 ,     //synchronizers for matastability
                                 rd_ptr_gray_sync1, rd_ptr_gray_sync2;      //synchronizers for metastability

    wire [$clog2(fifo_depth): 0]wr_ptr_next = wr_ptr + (wr_en && !full);                           // next write pointer logic
    wire [$clog2(fifo_depth): 0]wr_ptr_gray_next = wr_ptr_next ^ (wr_ptr_next >> 1);               // next gray write pointer logic 
    
    //write operation
    always @(posedge wr_clk or negedge wr_reset_n) begin
        if (wr_reset_n) begin
            wr_ptr <= 0;
            wr_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= data_in;                                         // write data to memory
            wr_ptr <= wr_ptr_next;
            wr_ptr_gray <= wr_ptr_gray_next;                                 // update gray pointer
        end 
    end

    //read operation
    wire [$clog2(fifo_depth): 0]rd_ptr_next = rd_ptr + (rd_en && !empty);                           // next read pointer logic
    wire [$clog2(fifo_depth): 0]rd_ptr_gray_next = rd_ptr_next ^ (rd_ptr_next >> 1);               // next gray read pointer logic


    always @(posedge rd_clk or negedge rd_reset_n) begin
        if (rd_reset_n) begin
            rd_ptr <= 0;
            rd_ptr_gray <= 0;
        end else if (rd_en && !empty) begin
            data_out <= mem[rd_ptr];                                         // read data from memory
            rd_ptr <= rd_ptr_next;
            rd_ptr_gray <= rd_ptr_gray_next;                                 // update gray pointer
        end 
    end

    //pont synchronizers for metastability - CDC methodology
        //SYNC WRITE PNTR TO READ DOMAIN
    always @(rd_clk or rd_reset_n) begin
        if (rd_reset_n) begin
            wr_ptr_gray_sync1<=0;
            wr_ptr_gray_sync2<=0;
        end
        else
        begin
            wr_ptr_gray_sync1<=wr_ptr_gray;
            wr_ptr_gray_sync2<=wr_ptr_gray_sync1;
        end
    end
        //sYNC READ PNTR TO WRITE DOMAIN
    always @(wr_clk or wr_reset_n) begin
        if (wr_reset_n) begin
            rd_ptr_gray_sync1<=0;
            rd_ptr_gray_sync2<=0;
        end
        else
        begin
            rd_ptr_gray_sync1<=rd_ptr_gray;
            rd_ptr_gray_sync2<=rd_ptr_gray_sync1;
        end
    end
    
    //functon for gray to binary conversion
    function [$clog2(fifo_depth):0] gray_to_bin;
        input [$clog2(fifo_depth):0] gray;
        integer i;
        ;
        begin
            gray_to_bin = gray[$clog2(fifo_depth):0]; // Initialize binary value
            for (i = $clog2(fifo_depth) - 1; i >= 0; i = i - 1) begin
                gray_to_bin[i] = gray_to_bin[i + 1] ^ gray[i];
            end
        end
        
    endfunction

    wire [$clog2(fifo_depth):0] wr_ptr_bin_sync = gray_to_bin(wr_ptr_gray_sync2); // convert gray to binary
    wire [$clog2(fifo_depth):0] rd_ptr_bin_sync = gray_to_bin(rd_ptr_gray_sync2); // convert gray to binary

    assign full = (wr_ptr_gray_next == {~rd_ptr_gray_sync2[$clog2(fifo_depth)], rd_ptr_gray_sync2[$clog2(fifo_depth) - 1:0]}) ? 1'b1 : 1'b0; // check if fifo is full- need sync write pointer to read domain
    assign empty = (rd_ptr_gray_sync2 == wr_ptr_gray_next) ? 1'b1 : 1'b0; // check if fifo is empty - need sync read pointer to write domain
endmodule