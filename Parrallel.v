module Parallel_control
(
    input wire [31:0] IU_OC_Instr,
    input wire oc_0_empty, oc_1_empty, oc_2_empty, oc_3_empty,
    input wire [2:0] IU_OC_HWWarp,
    input wire clk, rst,

    output reg [2:0] rowid_a, [1;0] bankid_a,
           reg [2:0] rowid_b, [1:0] bankid_b,
           reg [1:0] IU_OC_ocid,
    output wire ReqFIFO_2op_EN

);

//needs to introduce LUT
//ocid calculation
always @ (posedge clk)
begin
    if (oc_0_empty == 1) 
        IU_OC_ocid <= 2'b00;
    else if (oc_1_empty == 1)
        IU_OC_ocid <= 2'b01;
    else if (oc_2_empty == 1)
        IU_OC_ocid <= 2'b10;
    else if (oc_3_empty == 1)
        IU_OC_ocid <= 2'b11;
end



always @ (IU_OC_Instr or posedge clk)
begin
    if (rst = 1'b0) begin
        bankid_a <= 0;
        bankid_b <= 0;
        rowid_a <= 0;
        rowid_b <= 0;
    end else begin 
        case(IU_OC_Instr[23:21])
            3'b000:
                bankid_a <= LUT[IU_OC_HWWarp * 4][0] << 1;
                rowid_a <= LUT[IU_OC_HWWarp * 4][3:1];
            3'b001:
                bankid_a <= LUT[IU_OC_HWWarp * 4][0] << 1 + 1;
                rowid_a <= LUT[IU_OC_HWWarp * 4][3:1];
            3'b010:
                bankid_a <= LUT[IU_OC_HWWarp * 4 + 1][0] << 1;
                rowid_a <= LUT[IU_OC_HWWarp * 4 + 1][3:1];
            3'b011:
                bankid_a <= LUT[IU_OC_HWWarp * 4 + 1][0] << 1 + 1;
                rowid_a <= LUT[IU_OC_HWWarp * 4 + 1][3:1];
            3'b100:
                bankid_a <= LUT[IU_OC_HWWarp * 4 + 2][0] << 1;
                rowid_a <= LUT[IU_OC_HWWarp * 4 + 2][3:1];
            3'b101:
                bankid_a <= LUT[IU_OC_HWWarp * 4 + 2][0] << 1 + 1;
                rowid_a <= LUT[IU_OC_HWWarp * 4 + 2][3:1];
            3'b110:
                bankid_a <= LUT[IU_OC_HWWarp * 4 + 3][0] << 1;
                rowid_a <= LUT[IU_OC_HWWarp * 4 + 3][3:1];
            3'b111:
                bankid_a <= LUT[IU_OC_HWWarp * 4 + 3][0] << 1 + 1;
                rowid_a <= LUT[IU_OC_HWWarp * 4 + 3][3:1];
        endcase
        case(IU_OC_Instr[28:16])
            3'b000:
                bankid_b <= LUT[IU_OC_HWWarp * 4][0] << 1;
                rowid_b <= LUT[IU_OC_HWWarp * 4][3:1];
            3'b001:
                bankid_b <= LUT[IU_OC_HWWarp * 4][0] << 1 + 1;
                rowid_b <= LUT[IU_OC_HWWarp * 4][3:1];
            3'b010:
                bankid_b <= LUT[IU_OC_HWWarp * 4 + 1][0] << 1;
                rowid_b <= LUT[IU_OC_HWWarp * 4 + 1][3:1];
            3'b011:
                bankid_b <= LUT[IU_OC_HWWarp * 4 + 1][0] << 1 + 1;
                rowid_b <= LUT[IU_OC_HWWarp * 4 + 1][3:1];
            3'b100:
                bankid_b <= LUT[IU_OC_HWWarp * 4 + 2][0] << 1;
                rowid_b <= LUT[IU_OC_HWWarp * 4 + 2][3:1];
            3'b101:
                bankid_b <= LUT[IU_OC_HWWarp * 4 + 2][0] << 1 + 1;
                rowid_b <= LUT[IU_OC_HWWarp * 4 + 2][3:1];
            3'b110:
                bankid_b <= LUT[IU_OC_HWWarp * 4 + 3][0] << 1 ;
                rowid_b <= LUT[IU_OC_HWWarp * 4 + 3][3:1];
            3'b111:
                bankid_b <= LUT[IU_OC_HWWarp * 4 + 3][0] << 1 + 1;
                rowid_b <= LUT[IU_OC_HWWarp * 4 + 3][3:1];
        endcase
    end
end


