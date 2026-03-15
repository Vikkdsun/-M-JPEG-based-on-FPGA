module transpose_buffer #(
    parameter                       DIN_WIDTH      = 32                 ,
    parameter                       WINDOW_WIDTH   = 64*32              ,
) (
    input                           clk                 ,
    input                           rst_n               ,
    input  [64*(DIN_WIDTH+5)-1:0]   d1dct_out           ,
    input                           d1dct_valid         , 

    output [64*(DIN_WIDTH+5)-1:0]   trans_out           ,
    output                          trans_valid         
);

assign trans_out[64*(DIN_WIDTH+5)-1:56*(DIN_WIDTH+5)]   = {d1dct_out[64*(DIN_WIDTH+5)-1:63*(DIN_WIDTH+5)], d1dct_out[56*(DIN_WIDTH+5)-1:55*(DIN_WIDTH+5)], d1dct_out[48*(DIN_WIDTH+5)-1:47*(DIN_WIDTH+5)], d1dct_out[40*(DIN_WIDTH+5)-1:39*(DIN_WIDTH+5)], d1dct_out[32*(DIN_WIDTH+5)-1:31*(DIN_WIDTH+5)], d1dct_out[24*(DIN_WIDTH+5)-1:23*(DIN_WIDTH+5)], d1dct_out[16*(DIN_WIDTH+5)-1:15*(DIN_WIDTH+5)], d1dct_out[8*(DIN_WIDTH+5)-1:7*(DIN_WIDTH+5)]};
assign trans_out[56*(DIN_WIDTH+5)-1:48*(DIN_WIDTH+5)]   = {d1dct_out[63*(DIN_WIDTH+5)-1:62*(DIN_WIDTH+5)], d1dct_out[55*(DIN_WIDTH+5)-1:54*(DIN_WIDTH+5)], d1dct_out[47*(DIN_WIDTH+5)-1:46*(DIN_WIDTH+5)], d1dct_out[39*(DIN_WIDTH+5)-1:38*(DIN_WIDTH+5)], d1dct_out[31*(DIN_WIDTH+5)-1:30*(DIN_WIDTH+5)], d1dct_out[23*(DIN_WIDTH+5)-1:22*(DIN_WIDTH+5)], d1dct_out[15*(DIN_WIDTH+5)-1:14*(DIN_WIDTH+5)], d1dct_out[7*(DIN_WIDTH+5)-1:6*(DIN_WIDTH+5)]};
assign trans_out[48*(DIN_WIDTH+5)-1:40*(DIN_WIDTH+5)]   = {d1dct_out[62*(DIN_WIDTH+5)-1:61*(DIN_WIDTH+5)], d1dct_out[54*(DIN_WIDTH+5)-1:53*(DIN_WIDTH+5)], d1dct_out[46*(DIN_WIDTH+5)-1:45*(DIN_WIDTH+5)], d1dct_out[38*(DIN_WIDTH+5)-1:37*(DIN_WIDTH+5)], d1dct_out[30*(DIN_WIDTH+5)-1:29*(DIN_WIDTH+5)], d1dct_out[22*(DIN_WIDTH+5)-1:21*(DIN_WIDTH+5)], d1dct_out[14*(DIN_WIDTH+5)-1:13*(DIN_WIDTH+5)], d1dct_out[6*(DIN_WIDTH+5)-1:5*(DIN_WIDTH+5)]]};
assign trans_out[40*(DIN_WIDTH+5)-1:32*(DIN_WIDTH+5)]   = {d1dct_out[61*(DIN_WIDTH+5)-1:60*(DIN_WIDTH+5)], d1dct_out[53*(DIN_WIDTH+5)-1:52*(DIN_WIDTH+5)], d1dct_out[45*(DIN_WIDTH+5)-1:44*(DIN_WIDTH+5)], d1dct_out[37*(DIN_WIDTH+5)-1:36*(DIN_WIDTH+5)], d1dct_out[29*(DIN_WIDTH+5)-1:28*(DIN_WIDTH+5)], d1dct_out[21*(DIN_WIDTH+5)-1:20*(DIN_WIDTH+5)], d1dct_out[13*(DIN_WIDTH+5)-1:12*(DIN_WIDTH+5)], d1dct_out[5*(DIN_WIDTH+5)-1:4*(DIN_WIDTH+5)]]};
assign trans_out[32*(DIN_WIDTH+5)-1:24*(DIN_WIDTH+5)]   = {d1dct_out[60*(DIN_WIDTH+5)-1:59*(DIN_WIDTH+5)], d1dct_out[52*(DIN_WIDTH+5)-1:51*(DIN_WIDTH+5)], d1dct_out[44*(DIN_WIDTH+5)-1:43*(DIN_WIDTH+5)], d1dct_out[36*(DIN_WIDTH+5)-1:35*(DIN_WIDTH+5)], d1dct_out[28*(DIN_WIDTH+5)-1:27*(DIN_WIDTH+5)], d1dct_out[20*(DIN_WIDTH+5)-1:19*(DIN_WIDTH+5)], d1dct_out[12*(DIN_WIDTH+5)-1:11*(DIN_WIDTH+5)], d1dct_out[4*(DIN_WIDTH+5)-1:3*(DIN_WIDTH+5)]]};
assign trans_out[24*(DIN_WIDTH+5)-1:16*(DIN_WIDTH+5)]   = {d1dct_out[59*(DIN_WIDTH+5)-1:58*(DIN_WIDTH+5)], d1dct_out[51*(DIN_WIDTH+5)-1:50*(DIN_WIDTH+5)], d1dct_out[43*(DIN_WIDTH+5)-1:42*(DIN_WIDTH+5)], d1dct_out[35*(DIN_WIDTH+5)-1:34*(DIN_WIDTH+5)], d1dct_out[27*(DIN_WIDTH+5)-1:26*(DIN_WIDTH+5)], d1dct_out[19*(DIN_WIDTH+5)-1:18*(DIN_WIDTH+5)], d1dct_out[11*(DIN_WIDTH+5)-1:10*(DIN_WIDTH+5)], d1dct_out[3*(DIN_WIDTH+5)-1:2*(DIN_WIDTH+5)]]};
assign trans_out[16*(DIN_WIDTH+5)-1:8*(DIN_WIDTH+5)]    = {d1dct_out[58*(DIN_WIDTH+5)-1:57*(DIN_WIDTH+5)], d1dct_out[50*(DIN_WIDTH+5)-1:49*(DIN_WIDTH+5)], d1dct_out[42*(DIN_WIDTH+5)-1:41*(DIN_WIDTH+5)], d1dct_out[34*(DIN_WIDTH+5)-1:33*(DIN_WIDTH+5)], d1dct_out[26*(DIN_WIDTH+5)-1:25*(DIN_WIDTH+5)], d1dct_out[18*(DIN_WIDTH+5)-1:17*(DIN_WIDTH+5)], d1dct_out[10*(DIN_WIDTH+5)-1:9*(DIN_WIDTH+5)], d1dct_out[2*(DIN_WIDTH+5)-1:(DIN_WIDTH+5)]};
assign trans_out[8*(DIN_WIDTH+5)-1:0]                   = {d1dct_out[57*(DIN_WIDTH+5)-1:56*(DIN_WIDTH+5)], d1dct_out[49*(DIN_WIDTH+5)-1:48*(DIN_WIDTH+5)], d1dct_out[41*(DIN_WIDTH+5)-1:40*(DIN_WIDTH+5)], d1dct_out[33*(DIN_WIDTH+5)-1:32*(DIN_WIDTH+5)], d1dct_out[25*(DIN_WIDTH+5)-1:24*(DIN_WIDTH+5)], d1dct_out[17*(DIN_WIDTH+5)-1:16*(DIN_WIDTH+5)], d1dct_out[9*(DIN_WIDTH+5)-1:8*(DIN_WIDTH+5)], d1dct_out[(DIN_WIDTH+5)-1:0]};




endmodule
