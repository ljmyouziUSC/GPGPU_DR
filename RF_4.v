module RegisterFile(
    input wire [2:0] RF_Addr_0,
    input wire [2:0] RF_Addr_1,
    input wire [2:0] RF_Addr_2,
    input wire [2:0] RF_Addr_3,

    input wire [2:0] ocid_out_0,
    input wire [2:0] ocid_out_1,
    input wire [2:0] ocid_out_2,
    input wire [2:0] ocid_out_3,

    input wire RF_WR_0,
    input wire RF_WR_1,
    input wire RF_WR_2,
    input wire RF_WR_3,

    input wire [255:0] WriteData_0,
    input wire [255:0] WriteData_1,
    input wire [255:0] WriteData_2,
    input wire [255:0] WriteData_3,

    output wire [255:0] DataOut_0,
    output wire [255:0] DataOut_1,
    output wire [255:0] DataOut_2,
    output wire [255:0] DataOut_3,//不能写wire？

    
    output reg [2:0] ocid_0,
    output reg [2:0] ocid_1,
    output reg [2:0] ocid_2,
    output reg [2:0] ocid_3
);


always @ (posedge clk)
begin
    ocid_0 <= ocid_out_0;
    ocid_1 <= ocid_out_1;
    ocid_2 <= ocid_out_2;
    ocid_3 <= ocid_out_3;
end

Inferable_BRAM RF_0(

    // Port A
    .a_clk(clk),
    .a_wr(RF_WR_0),
    .a_addr(RF_Addr_0),
    .a_din(WriteData_0),
    .a_dout(DataOut_0),
     
    // Port B
    .b_clk(clk),
    .b_wr(RF_WR_0),
    .b_addr(RF_Addr_0),
    .b_din(WriteData_0),
    .b_dout()
);

Inferable_BRAM RF_1(
    // Port A
    .a_clk(clk),
    .a_wr(RF_WR_1),
    .a_addr(RF_Addr_1),
    .a_din(WriteData_1),
    .a_dout(DataOut_1),
     
    // Port B
    .b_clk(clk),
    .b_wr(RF_WR_1),
    .b_addr(RF_Addr_1),
    .b_din(WriteData_1),
    .b_dout()
);

Inferable_BRAM RF_2(
    // Port A
    .a_clk(clk),
    .a_wr(RF_WR_2),
    .a_addr(RF_Addr_2),
    .a_din(WriteData_2),
    .a_dout(DataOut_2),
     
    // Port B
    .b_clk(clk),
    .b_wr(RF_WR_2),
    .b_addr(RF_Addr_2),
    .b_din(WriteData_2),
    .b_dout()
);

Inferable_BRAM RF_3(
    // Port A
    .a_clk(clk),
    .a_wr(RF_WR_3),
    .a_addr(RF_Addr_3),
    .a_din(WriteData_3),
    .a_dout(DataOut_3),
     
    // Port B
    .b_clk(clk),
    .b_wr(RF_WR_3),
    .b_addr(RF_Addr_3),
    .b_din(WriteData_3),
    .b_dout()
);
endmodule