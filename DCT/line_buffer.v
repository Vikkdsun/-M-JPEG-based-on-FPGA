module line_buffer #(
    parameter               DIN_WIDTH   = 32        ,
    parameter               DOUT_WIDTH  = 64*32     ,
    parameter               LINE_LEN    = 16    
)(
    input                   clk                 ,
    input                   rst_n               ,
    input  [DIN_WIDTH-1:0]  data_in             ,
    input                   line_en             ,
    output [DOUT_WIDTH-1:0] data_out            ,
    output                  data_out_valid      
);

/* 输入进该模块之前 需要先把图像行列0扩充到可以被8整除 */


assign data_out = {window0, window1, window2, window3, window4, window5, window6, window7};
assign data_out_valid = window_valid;

wire window7_shift_en = line_en && line_cnt == 7;
reg  window6_shift_en;
reg  window5_shift_en;
reg  window4_shift_en;
reg  window3_shift_en;
reg  window2_shift_en;
reg  window1_shift_en;
reg  window0_shift_en;

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        window6_shift_en <= 0;
        window5_shift_en <= 0;
        window4_shift_en <= 0;
        window3_shift_en <= 0;
        window2_shift_en <= 0;
        window1_shift_en <= 0;
        window0_shift_en <= 0;
    end else begin
        window6_shift_en <= window7_shift_en;
        window5_shift_en <= window6_shift_en;
        window4_shift_en <= window5_shift_en;
        window3_shift_en <= window4_shift_en;
        window2_shift_en <= window3_shift_en;
        window1_shift_en <= window2_shift_en;
        window0_shift_en <= window1_shift_en;
    end
end

/* line cnt */
reg line_en_d1;
reg line_en_d2;
reg line_en_d3;
reg line_en_d4;
reg line_en_d5;
reg line_en_d6;
reg line_en_d7;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        line_en_d1 <= 0;
        line_en_d2 <= 0;
        line_en_d3 <= 0;
        line_en_d4 <= 0;
        line_en_d5 <= 0;
        line_en_d6 <= 0;
        line_en_d7 <= 0;
    end else begin
        line_en_d1 <= line_en;
        line_en_d2 <= line_en_d1;
        line_en_d3 <= line_en_d2;
        line_en_d4 <= line_en_d3;
        line_en_d5 <= line_en_d4;
        line_en_d6 <= line_en_d5;
        line_en_d7 <= line_en_d6;
    end
end

wire line_en_neg = line_en_d1 & ~line_en;
reg [2:0] line_cnt;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        line_cnt <= 0;
    else if (line_en_neg && line_cnt == 7)
        line_cnt <= 0;
    else if (line_en_neg)
        line_cnt <= line_cnt + 1;
end

/* fifo dout */

wire [DIN_WIDTH-1:0] fifo7_dout;
wire [DIN_WIDTH-1:0] fifo6_dout;
wire [DIN_WIDTH-1:0] fifo5_dout;
wire [DIN_WIDTH-1:0] fifo4_dout;
wire [DIN_WIDTH-1:0] fifo3_dout;
wire [DIN_WIDTH-1:0] fifo2_dout;
wire [DIN_WIDTH-1:0] fifo1_dout;
wire [DIN_WIDTH-1:0] fifo0_dout;

/* window */
reg [8*DIN_WIDTH-1:0] window0;
reg [8*DIN_WIDTH-1:0] window1;
reg [8*DIN_WIDTH-1:0] window2;
reg [8*DIN_WIDTH-1:0] window3;
reg [8*DIN_WIDTH-1:0] window4;
reg [8*DIN_WIDTH-1:0] window5;
reg [8*DIN_WIDTH-1:0] window6;
reg [8*DIN_WIDTH-1:0] window7;

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        window7 <= 0;
    end else if (window7_shift_en) begin
        window7 <= {window7[7*DIN_WIDTH-1:0], data_in};
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        window6 <= 0;
    end else if (window6_shift_en) begin
        window6 <= {window6[7*DIN_WIDTH-1:0], fifo6_dout};
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        window5 <= 0;
    end else if (window5_shift_en) begin
        window5 <= {window5[7*DIN_WIDTH-1:0], fifo5_dout};
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        window4 <= 0;
    end else if (window4_shift_en) begin
        window4 <= {window4[7*DIN_WIDTH-1:0], fifo4_dout};
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        window3 <= 0;
    end else if (window3_shift_en) begin
        window3 <= {window3[7*DIN_WIDTH-1:0], fifo3_dout};
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        window2 <= 0;
    end else if (window2_shift_en) begin
        window2 <= {window2[7*DIN_WIDTH-1:0], fifo2_dout};
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        window1 <= 0;
    end else if (window1_shift_en) begin
        window1 <= {window1[7*DIN_WIDTH-1:0], fifo1_dout};
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        window0 <= 0;
    end else if (window0_shift_en) begin
        window0 <= {window0[7*DIN_WIDTH-1:0], fifo0_dout};
    end
end

/* window pixel cnt */
reg [2:0] pixel_cnt;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        pixel_cnt <= 0;
    else if (window0_shift_en) begin
        if (pixel_cnt == 7)
            pixel_cnt <= 0;
        else
            pixel_cnt <= pixel_cnt + 1;
    end
end

reg window_valid;   // synce with window1-7 
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        window_valid <= 0;
    else if (window0_shift_en && pixel_cnt == 7)
        window_valid <= 1;
    else
        window_valid <= 0;  
end

/* 8 linebuffer */
fifo #(
    .DATA_WIDTH     (DIN_WIDTH  )     ,
    .DEPTH          (LINE_LEN   )         
)fifo_line0(
    .clk                 (clk  ),
    .rst                 (rst_n),
    .wr_en               (line_en_d7),
    .rd_en               (line_en_d7),
    .din                 (fifo1_dout),
    .dout                (fifo0_dout)
);

fifo #(
    .DATA_WIDTH     (DIN_WIDTH  )     ,
    .DEPTH          (LINE_LEN   )         
)fifo_line1(
    .clk                 (clk  ),
    .rst                 (rst_n),
    .wr_en               (line_en_d6),
    .rd_en               (line_en_d6),
    .din                 (fifo2_dout),
    .dout                (fifo1_dout)
);

fifo #(
    .DATA_WIDTH     (DIN_WIDTH  )     ,
    .DEPTH          (LINE_LEN   )         
)fifo_line2(
    .clk                 (clk  ),
    .rst                 (rst_n),
    .wr_en               (line_en_d5),
    .rd_en               (line_en_d5),
    .din                 (fifo3_dout),
    .dout                (fifo2_dout)
);

fifo #(
    .DATA_WIDTH     (DIN_WIDTH  )     ,
    .DEPTH          (LINE_LEN   )         
)fifo_line3(
    .clk                 (clk  ),
    .rst                 (rst_n),
    .wr_en               (line_en_d4),
    .rd_en               (line_en_d4),
    .din                 (fifo4_dout),
    .dout                (fifo3_dout)
);

fifo #(
    .DATA_WIDTH     (DIN_WIDTH  )     ,
    .DEPTH          (LINE_LEN   )         
)fifo_line4(
    .clk                 (clk  ),
    .rst                 (rst_n),
    .wr_en               (line_en_d3),
    .rd_en               (line_en_d3),
    .din                 (fifo5_dout),
    .dout                (fifo4_dout)
);

fifo #(
    .DATA_WIDTH     (DIN_WIDTH  )     ,
    .DEPTH          (LINE_LEN   )         
)fifo_line5(
    .clk                 (clk  ),
    .rst                 (rst_n),
    .wr_en               (line_en_d2),
    .rd_en               (line_en_d2),
    .din                 (fifo6_dout),
    .dout                (fifo5_dout)
);

fifo #(
    .DATA_WIDTH     (DIN_WIDTH  )     ,
    .DEPTH          (LINE_LEN   )         
)fifo_line6(
    .clk                 (clk  ),
    .rst                 (rst_n),
    .wr_en               (line_en_d1),
    .rd_en               (line_en_d1),
    .din                 (fifo7_dout),
    .dout                (fifo6_dout)
);

fifo #(
    .DATA_WIDTH     (DIN_WIDTH  )     ,
    .DEPTH          (LINE_LEN   )         
)fifo_line7(
    .clk                 (clk  ),
    .rst                 (rst_n),
    .wr_en               (line_en),
    .rd_en               (line_en),
    .din                 (data_in   ),
    .dout                (fifo7_dout)
); 











endmodule
