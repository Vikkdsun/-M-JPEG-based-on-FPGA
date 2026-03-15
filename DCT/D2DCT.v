module D2DCT #(
    parameter                       DIN_WIDTH      = 32                 ,
    parameter                       WINDOW_WIDTH   = 64*32              ,
    parameter                       LINE_LEN       = 16                 ,
    parameter                       M1             = 35'h0000_0000      , // cos(pi/16)*sqrt(2) * 2^16
    parameter                       M2             = 35'h0000_0000      , // cos(pi/16)*sqrt(2) * 2^16
    parameter                       M3             = 35'h0000_0000      , // cos(pi/16)*sqrt(2) * 2^16
    parameter                       M4             = 35'h0000_0000        // cos(pi/16)*sqrt(2) * 2^16
)(
    input                           clk                 ,
    input                           rst_n               ,
    input  [DIN_WIDTH-1:0]          data_in             ,
    input                           line_en             ,

    output [64*(DIN_WIDTH+5)-1:0]   d2dct_out           ,
    output                          d2dct_valid         ,

    output [64*(DIN_WIDTH+5)-1:0]   d2dct_out           ,
    output                          d2dct_valid         
);

wire [WINDOW_WIDTH-1:0]  x8data_out                     ;
wire                     x8data_out_valid               ;

wire [64*(DIN_WIDTH+5)-1:0]   d1dct_out  ;
wire                          d1dct_valid;

wire [64*(DIN_WIDTH+5)-1:0]   trans_out  ;
wire                          trans_valid;

line_buffer #(
    .DIN_WIDTH          (DIN_WIDTH      ),
    .DOUT_WIDTH         (WINDOW_WIDTH   ),
    .LINE_LEN           (LINE_LEN       )  
)line_buffer_u(
    .clk                 (clk    ),
    .rst_n               (rst_n  ),
    .data_in             (data_in),
    .line_en             (line_en),
    .data_out            (x8data_out      ),
    .data_out_valid      (x8data_out_valid)
);

D1DCT #(
    .DIN_WIDTH          (DIN_WIDTH   ),
    .WINDOW_WIDTH       (WINDOW_WIDTH),
    .M1                 (M1          ), // cos(pi/16)*sqrt(2) * 2^16
    .M2                 (M2          ), // cos(pi/16)*sqrt(2) * 2^16
    .M3                 (M3          ), // cos(pi/16)*sqrt(2) * 2^16
    .M4                 (M4          )  // cos(pi/16)*sqrt(2) * 2^16
)D1DCT_u1(
    .clk                 (clk    ),
    .rst_n               (rst_n  ),
    .wind_in             (x8data_out      ),
    .wind_valid          (x8data_out_valid), 

    .d1dct_out           (d1dct_out  ),
    .d1dct_valid         (d1dct_valid)
);

transpose_buffer #(
    .DIN_WIDTH      (DIN_WIDTH   ),
    .WINDOW_WIDTH   (WINDOW_WIDTH),
)transpose_buffer_u(
    .clk                 (clk  ),
    .rst_n               (rst_n),
    .d1dct_out           (d1dct_out  ),
    .d1dct_valid         (d1dct_valid), 

    .trans_out           (trans_out  ),
    .trans_valid         (trans_valid)
);

D1DCT #(
    .DIN_WIDTH          (DIN_WIDTH   ),
    .WINDOW_WIDTH       (WINDOW_WIDTH),
    .M1                 (M1          ), // cos(pi/16)*sqrt(2) * 2^16
    .M2                 (M2          ), // cos(pi/16)*sqrt(2) * 2^16
    .M3                 (M3          ), // cos(pi/16)*sqrt(2) * 2^16
    .M4                 (M4          )  // cos(pi/16)*sqrt(2) * 2^16
)D1DCT_u2(
    .clk                 (clk    ),
    .rst_n               (rst_n  ),
    .wind_in             (trans_out  ),
    .wind_valid          (trans_valid), 

    .d1dct_out           (d2dct_out  ),
    .d1dct_valid         (d2dct_valid)
);





endmodule
