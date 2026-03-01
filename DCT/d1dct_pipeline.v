module d1dct_pipeline #(
    parameter                   DIN_WIDTH      = 32           ,
    parameter                   WINDOW_WIDTH   = 64*32        ,
    parameter                   M1             = 35'h0000_0000   , // cos(pi/16)*sqrt(2) * 2^16
)(
    input                       clk                 ,
    input                       rst_n               ,
    input  [WINDOW_WIDTH-1:0]   wind_in             ,
    input                       wind_valid          , 
);

// unpack

wire [WINDOW_WIDTH-1:(WINDOW_WIDTH/DIN_WIDTH-8)*DIN_WIDTH]                              wind_line1;
wire [(WINDOW_WIDTH/DIN_WIDTH-8)*DIN_WIDTH-1:(WINDOW_WIDTH/DIN_WIDTH-16)*DIN_WIDTH]     wind_line2;
wire [(WINDOW_WIDTH/DIN_WIDTH-16)*DIN_WIDTH-1:(WINDOW_WIDTH/DIN_WIDTH-24)*DIN_WIDTH]    wind_line3;
wire [(WINDOW_WIDTH/DIN_WIDTH-24)*DIN_WIDTH-1:(WINDOW_WIDTH/DIN_WIDTH-32)*DIN_WIDTH]    wind_line4;
wire [(WINDOW_WIDTH/DIN_WIDTH-32)*DIN_WIDTH-1:(WINDOW_WIDTH/DIN_WIDTH-40)*DIN_WIDTH]    wind_line5;
wire [(WINDOW_WIDTH/DIN_WIDTH-40)*DIN_WIDTH-1:(WINDOW_WIDTH/DIN_WIDTH-48)*DIN_WIDTH]    wind_line6;
wire [(WINDOW_WIDTH/DIN_WIDTH-48)*DIN_WIDTH-1:(WINDOW_WIDTH/DIN_WIDTH-56)*DIN_WIDTH]    wind_line7;
wire [(WINDOW_WIDTH/DIN_WIDTH-56)*DIN_WIDTH-1:(WINDOW_WIDTH/DIN_WIDTH-64)*DIN_WIDTH]    wind_line8;

// 1D DCT input
wire [DIN_WIDTH-1:0] dct_a0 = wind_line1[8*DIN_WIDTH-1:8*DIN_WIDTH-DIN_WIDTH];
wire [DIN_WIDTH-1:0] dct_a1 = wind_line1[7*DIN_WIDTH-1:7*DIN_WIDTH-DIN_WIDTH];
wire [DIN_WIDTH-1:0] dct_a2 = wind_line1[6*DIN_WIDTH-1:6*DIN_WIDTH-DIN_WIDTH];
wire [DIN_WIDTH-1:0] dct_a3 = wind_line1[5*DIN_WIDTH-1:5*DIN_WIDTH-DIN_WIDTH];
wire [DIN_WIDTH-1:0] dct_a4 = wind_line1[4*DIN_WIDTH-1:4*DIN_WIDTH-DIN_WIDTH];
wire [DIN_WIDTH-1:0] dct_a5 = wind_line1[3*DIN_WIDTH-1:3*DIN_WIDTH-DIN_WIDTH];
wire [DIN_WIDTH-1:0] dct_a6 = wind_line1[2*DIN_WIDTH-1:2*DIN_WIDTH-DIN_WIDTH];
wire [DIN_WIDTH-1:0] dct_a7 = wind_line1[1*DIN_WIDTH-1:1*DIN_WIDTH-DIN_WIDTH];

// piepeline1 : step1

wire [DIN_WIDTH:0] dct_b0;
wire [DIN_WIDTH:0] dct_b1;
wire [DIN_WIDTH:0] dct_b2;
wire [DIN_WIDTH:0] dct_b3;
wire [DIN_WIDTH:0] dct_b4;
wire [DIN_WIDTH:0] dct_b5;
wire [DIN_WIDTH:0] dct_b6;
wire [DIN_WIDTH:0] dct_b7;

assign dct_b0 = dct_a0 + dct_a7;
assign dct_b1 = dct_a1 + dct_a6;
assign dct_b2 = dct_a3 - dct_a4;
assign dct_b3 = dct_a1 - dct_a6;
assign dct_b4 = dct_a2 + dct_a5;
assign dct_b5 = dct_a3 + dct_a4;
assign dct_b6 = dct_a2 - dct_a5;
assign dct_b7 = dct_a0 - dct_a7;

reg [DIN_WIDTH:0] rdct_b0;
reg [DIN_WIDTH:0] rdct_b1;
reg [DIN_WIDTH:0] rdct_b2;
reg [DIN_WIDTH:0] rdct_b3;
reg [DIN_WIDTH:0] rdct_b4;
reg [DIN_WIDTH:0] rdct_b5;
reg [DIN_WIDTH:0] rdct_b6;
reg [DIN_WIDTH:0] rdct_b7;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rdct_b0 <= 0;
        rdct_b1 <= 0;
        rdct_b2 <= 0;
        rdct_b3 <= 0;
        rdct_b4 <= 0;
        rdct_b5 <= 0;
        rdct_b6 <= 0;
        rdct_b7 <= 0;
    end else begin
        rdct_b0 <= dct_b0;
        rdct_b1 <= dct_b1;
        rdct_b2 <= dct_b2;
        rdct_b3 <= dct_b3;
        rdct_b4 <= dct_b4;
        rdct_b5 <= dct_b5;
        rdct_b6 <= dct_b6;
        rdct_b7 <= dct_b7;
    end
end

// pipeline2 : step2

wire [DIN_WIDTH+1:0] dct_c0;
wire [DIN_WIDTH+1:0] dct_c1;
wire [DIN_WIDTH+1:0] dct_c2;
wire [DIN_WIDTH+1:0] dct_c3;
wire [DIN_WIDTH+1:0] dct_c4;
wire [DIN_WIDTH+1:0] dct_c5;
wire [DIN_WIDTH+1:0] dct_c6;
wire [DIN_WIDTH+1:0] dct_c7;

assign dct_c0 = rdct_b0 + rdct_b5;
assign dct_c1 = rdct_b1 - rdct_b4;
assign dct_c2 = rdct_b2 + rdct_b6;
assign dct_c3 = rdct_b1 + rdct_b4;
assign dct_c4 = rdct_b0 - rdct_b5;
assign dct_c5 = rdct_b3 + rdct_b7;
assign dct_c6 = rdct_b3 + rdct_b6;
assign dct_c7 = rdct_b7;

reg [DIN_WIDTH+1:0] rdct_c0;
reg [DIN_WIDTH+1:0] rdct_c1;
reg [DIN_WIDTH+1:0] rdct_c2;
reg [DIN_WIDTH+1:0] rdct_c3;
reg [DIN_WIDTH+1:0] rdct_c4;
reg [DIN_WIDTH+1:0] rdct_c5;
reg [DIN_WIDTH+1:0] rdct_c6;
reg [DIN_WIDTH+1:0] rdct_c7;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rdct_c0 <= 0;
        rdct_c1 <= 0;
        rdct_c2 <= 0;
        rdct_c3 <= 0;
        rdct_c4 <= 0;
        rdct_c5 <= 0;
        rdct_c6 <= 0;
        rdct_c7 <= 0;
    end else begin
        rdct_c0 <= dct_c0;
        rdct_c1 <= dct_c1;
        rdct_c2 <= dct_c2;
        rdct_c3 <= dct_c3;
        rdct_c4 <= dct_c4;
        rdct_c5 <= dct_c5;
        rdct_c6 <= dct_c6;
        rdct_c7 <= dct_c7;
    end
end

// pipeline3 : step3

wire [DIN_WIDTH+2:0] dct_d0;
wire [DIN_WIDTH+2:0] dct_d1;
wire [DIN_WIDTH+2:0] dct_d2;
wire [DIN_WIDTH+2:0] dct_d3;
wire [DIN_WIDTH+2:0] dct_d4;
wire [DIN_WIDTH+2:0] dct_d5;
wire [DIN_WIDTH+2:0] dct_d6;
wire [DIN_WIDTH+2:0] dct_d7;
wire [DIN_WIDTH+2:0] dct_d8;

assign dct_d0 = rdct_c0 + rdct_c3;
assign dct_d1 = rdct_c0 - rdct_c3;
assign dct_d2 = rdct_c2;
assign dct_d3 = rdct_c1 + rdct_c4;
assign dct_d4 = rdct_c2 - rdct_c5;
assign dct_d5 = rdct_c4;
assign dct_d6 = rdct_c5;
assign dct_d7 = rdct_c6;
assign dct_d8 = rdct_c7;

reg [DIN_WIDTH+2:0] rdct_d0;
reg [DIN_WIDTH+2:0] rdct_d1;
reg [DIN_WIDTH+2:0] rdct_d2;
reg [DIN_WIDTH+2:0] rdct_d3;
reg [DIN_WIDTH+2:0] rdct_d4;
reg [DIN_WIDTH+2:0] rdct_d5;
reg [DIN_WIDTH+2:0] rdct_d6;
reg [DIN_WIDTH+2:0] rdct_d7;
reg [DIN_WIDTH+2:0] rdct_d8;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rdct_d0 <= 0;
        rdct_d1 <= 0;
        rdct_d2 <= 0;
        rdct_d3 <= 0;
        rdct_d4 <= 0;
        rdct_d5 <= 0;
        rdct_d6 <= 0;
        rdct_d7 <= 0;
        rdct_d8 <= 0;
    end else begin
        rdct_d0 <= dct_d0;
        rdct_d1 <= dct_d1;
        rdct_d2 <= dct_d2;
        rdct_d3 <= dct_d3;
        rdct_d4 <= dct_d4;
        rdct_d5 <= dct_d5;
        rdct_d6 <= dct_d6;
        rdct_d7 <= dct_d7;
        rdct_d8 <= dct_d8;
    end
end


// pipeline4 : step4



















endmodule
