`default_nettype none

module ReqFIFO_4(
    input wire rst,
    input wire clk,


    input wire WriteValid,

    input wire [1:0] WriteBank,
    input wire [2:0] WriteRow,
    
    input Src1_Valid,
    input [1:0] Src1_Phy_Bank_ID,
    input [2:0] Src1_Phy_Row_ID,
    input Src2_Valid,
    input [1:0] Src2_Phy_Bank_ID,
    input [2:0] Src2_Phy_Row_ID,
    input ReqFIFO_2op_EN,
    
    input [3:0] OCID_RAU_OC,

    input [255:0] Data_CDB,

    output [2:0] RF_Addr_0,
    output [2:0] RF_Addr_1,
    output [2:0] RF_Addr_2,
    output [2:0] RF_Addr_3,

    output [3:0] ocid_out_0,
    output [3:0] ocid_out_1,
    output [3:0] ocid_out_2,
    output [3:0] ocid_out_3,

    output RF_WR_0,
    output RF_WR_1,
    output RF_WR_2,
    output RF_WR_3,

    output [255:0] WriteData_0,
    output [255:0] WriteData_1,
    output [255:0] WriteData_2,
    output [255:0] WriteData_3
);


wire ReqFIFO_2op_EN_0 = ReqFIFO_2op_EN & (Src1_Phy_Bank_ID == 2'b00);
wire ReqFIFO_2op_EN_1 = ReqFIFO_2op_EN & (Src1_Phy_Bank_ID == 2'b01);
wire ReqFIFO_2op_EN_2 = ReqFIFO_2op_EN & (Src1_Phy_Bank_ID == 2'b10);
wire ReqFIFO_2op_EN_3 = ReqFIFO_2op_EN & (Src1_Phy_Bank_ID == 2'b11);

wire [2:0] Src1_Phy_Row_ID_0 = Src1_Phy_Row_ID;
wire [2:0] Src1_Phy_Row_ID_1 = Src1_Phy_Row_ID;
wire [2:0] Src1_Phy_Row_ID_2 = Src1_Phy_Row_ID;
wire [2:0] Src1_Phy_Row_ID_3 = Src1_Phy_Row_ID;

wire [2:0] Src2_Phy_Row_ID_0 = Src2_Phy_Row_ID;
wire [2:0] Src2_Phy_Row_ID_1 = Src2_Phy_Row_ID;
wire [2:0] Src2_Phy_Row_ID_2 = Src2_Phy_Row_ID;
wire [2:0] Src2_Phy_Row_ID_3 = Src2_Phy_Row_ID;

wire [3:0] OCID_RAU_OC_0 = OCID_RAU_OC;
wire [3:0] OCID_RAU_OC_1 = OCID_RAU_OC;
wire [3:0] OCID_RAU_OC_2 = OCID_RAU_OC;
wire [3:0] OCID_RAU_OC_3 = OCID_RAU_OC;

wire RF_Read_Valid_0 = ((Src1_Phy_Bank_ID ==  4'b0001)&(Src1_Valid)) | ((Src2_Phy_Bank_ID == 4'b0001) & (Src2_Valid));
wire RF_Read_Valid_1 = ((Src1_Phy_Bank_ID ==  4'b0010)&(Src1_Valid)) | ((Src2_Phy_Bank_ID == 4'b0010) & (Src2_Valid));
wire RF_Read_Valid_2 = ((Src1_Phy_Bank_ID ==  4'b0100)&(Src1_Valid)) | ((Src2_Phy_Bank_ID == 4'b0100) & (Src2_Valid));
wire RF_Read_Valid_3 = ((Src1_Phy_Bank_ID ==  4'b1000)&(Src1_Valid)) | ((Src2_Phy_Bank_ID == 4'b1000) & (Src2_Valid));

wire RF_Write_Valid_0 = (WriteBank == 2'b00) & (WriteValid);
wire RF_Write_Valid_1 = (WriteBank == 2'b01) & (WriteValid);
wire RF_Write_Valid_2 = (WriteBank == 2'b10) & (WriteValid);
wire RF_Write_Valid_3 = (WriteBank == 2'b11) & (WriteValid);


ReqFIFO Req0(
    .rst(rst),
    .clk(clk),

    .ReqFIFO_2op_EN(ReqFIFO_2op_EN_0),
    .Src1_Phy_Row_ID(Src1_Phy_Row_ID_0), 
    .Src2_Phy_Row_ID(Src2_Phy_Row_ID_0),
    .OCID_RAU_OC(OCID_RAU_OC_0),
    .RF_Read_Valid(RF_Read_Valid_0),
    .RF_Write_Valid(RF_Write_Valid_0),
    .WriteRow(WriteRow),
    .Data_CDB(Data_CDB),

    .RF_Addr(RF_Addr_0),
    .ocid_out(ocid_out_0),
    .RF_WR(RF_WR_0),

    .WriteData(WriteData_0)
);

ReqFIFO Req1(
    .rst(rst),
    .clk(clk),

    .ReqFIFO_2op_EN(ReqFIFO_2op_EN_1),
    .Src1_Phy_Row_ID(Src1_Phy_Row_ID_1), 
    .Src2_Phy_Row_ID(Src2_Phy_Row_ID_1),
    .OCID_RAU_OC(OCID_RAU_OC_1),
    .RF_Read_Valid(RF_Read_Valid_1),
    .RF_Write_Valid(RF_Write_Valid_1),
    .WriteRow(WriteRow),
    .Data_CDB(Data_CDB),

    .RF_Addr(RF_Addr_1),
    .ocid_out(ocid_out_1),
    .RF_WR(RF_WR_1),

    .WriteData(WriteData_1)
);

ReqFIFO Req2(
    .rst(rst),
    .clk(clk),

    .ReqFIFO_2op_EN(ReqFIFO_2op_EN_2),
    .Src1_Phy_Row_ID(Src1_Phy_Row_ID_2), 
    .Src2_Phy_Row_ID(Src2_Phy_Row_ID_2),
    .OCID_RAU_OC(OCID_RAU_OC_2),
    .RF_Read_Valid(RF_Read_Valid_2),
    .RF_Write_Valid(RF_Write_Valid_2),
    .WriteRow(WriteRow),
    .Data_CDB(Data_CDB),

    .RF_Addr(RF_Addr_2),
    .ocid_out(ocid_out_2),
    .RF_WR(RF_WR_2),

    .WriteData(WriteData_2)
);

ReqFIFO Req3(
    .rst(rst),
    .clk(clk),

    .ReqFIFO_2op_EN(ReqFIFO_2op_EN_3),
    .Src1_Phy_Row_ID(Src1_Phy_Row_ID_3), 
    .Src2_Phy_Row_ID(Src2_Phy_Row_ID_3),
    .OCID_RAU_OC(OCID_RAU_OC_3),
    .RF_Read_Valid(RF_Read_Valid_3),
    .RF_Write_Valid(RF_Write_Valid_3),
    .WriteRow(WriteRow),
    .Data_CDB(Data_CDB),

    .RF_Addr(RF_Addr_3),
    .ocid_out(ocid_out_3),
    .RF_WR(RF_WR_3),

    .WriteData(WriteData_3)
);

endmodule
