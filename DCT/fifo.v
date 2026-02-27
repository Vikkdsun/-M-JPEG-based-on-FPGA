module fifo #(
    parameter                       DATA_WIDTH  = 8     ,
    parameter                       DEPTH       = 16    
)(
    input wire                      clk                 ,
    input wire                      rst                 ,
    input wire                      wr_en               ,
    input wire                      rd_en               ,
    input wire [DATA_WIDTH-1:0]     din                 ,
    output reg  [DATA_WIDTH-1:0]    dout                
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [$clog2(DEPTH):0] wr_ptr, rd_ptr;
    // reg [$clog2(DEPTH+1)-1:0] count;

    // assign full  = (count == DEPTH);
    // assign empty = (count == 0);
    
    // assign  dout = mem[rd_ptr[$clog2(DEPTH)-1:0]];

    genvar i;
    generate
        for (i = 0; i < DEPTH; i = i + 1) begin : mem_init
            always @(posedge clk or negedge rst) begin
                if (rst)
                    mem[i] <= 0;
                else if (wr_en && (wr_ptr[$clog2(DEPTH)-1:0] == i))
                    mem[i] <= din;
            end
        end
    endgenerate

    always @(posedge clk or negedge rst) begin
        if (rst)
            wr_ptr <= 0;
        else if (wr_en)
            wr_ptr <= wr_ptr + 1;
    end

    always @(posedge clk or negedge rst) begin
        if (rst)
            rd_ptr <= 0;
        else if (rd_en)
            rd_ptr <= rd_ptr + 1;
    end


    always @(posedge clk or negedge rst) begin
        if (rst)
            dout <= 0;
        else if (rd_en)   
            dout <= mem[rd_ptr[$clog2(DEPTH)-1:0]];
    end


endmodule
