module Parallel_control
(
    input wire [31:0] Instr_IU_OC,
    input wire oc_0_empty, oc_1_empty, oc_2_empty, oc_3_empty,
    input wire [2:0] HWWarp_IU_OC,
    input wire clk, rst,

    output reg [2:0] rowid_a, 
    output reg [1:0] bankid_a,
    output reg [2:0] rowid_b, 
    output reg [1:0] bankid_b,
    output reg [1:0] ocid_IU_OC,
    output wire ReqFIFO_2op_EN

);
reg [4:0] LUT [31:0];

//needs to introduce LUT
//ocid calculation
always @ (posedge clk)
begin
    if (oc_0_empty == 1) 
        ocid_IU_OC <= 2'b00;
    else if (oc_1_empty == 1)
        ocid_IU_OC <= 2'b01;
    else if (oc_2_empty == 1)
        ocid_IU_OC <= 2'b10;
    else if (oc_3_empty == 1)
        ocid_IU_OC <= 2'b11;
end



always @ (Instr_IU_OC or posedge clk)
begin
    if (rst == 1'b0) begin
        bankid_a <= 0;
        bankid_b <= 0;
        rowid_a <= 0;
        rowid_b <= 0;
    end else begin 
        case(Instr_IU_OC[23:21]) 
            3'b000: begin
                bankid_a <= LUT[HWWarp_IU_OC * 4][0] << 1;
                rowid_a <= LUT[HWWarp_IU_OC * 4][3:1];
                end
            3'b001: begin
                bankid_a <= LUT[HWWarp_IU_OC * 4][0] << 1 + 1;
                rowid_a <= LUT[HWWarp_IU_OC * 4][3:1];
                end
            3'b010: begin
                bankid_a <= LUT[HWWarp_IU_OC * 4 + 1][0] << 1;
                rowid_a <= LUT[HWWarp_IU_OC * 4 + 1][3:1];
                end
            3'b011: begin
                bankid_a <= LUT[HWWarp_IU_OC * 4 + 1][0] << 1 + 1;
                rowid_a <= LUT[HWWarp_IU_OC * 4 + 1][3:1];
                end
            3'b100: begin
                bankid_a <= LUT[HWWarp_IU_OC * 4 + 2][0] << 1;
                rowid_a <= LUT[HWWarp_IU_OC * 4 + 2][3:1];
                end
            3'b101: begin
                bankid_a <= LUT[HWWarp_IU_OC * 4 + 2][0] << 1 + 1;
                rowid_a <= LUT[HWWarp_IU_OC * 4 + 2][3:1];
                end
            3'b110: begin 
                bankid_a <= LUT[HWWarp_IU_OC * 4 + 3][0] << 1;
                rowid_a <= LUT[HWWarp_IU_OC * 4 + 3][3:1];
                end
            3'b111: begin
                bankid_a <= LUT[HWWarp_IU_OC * 4 + 3][0] << 1 + 1;
                rowid_a <= LUT[HWWarp_IU_OC * 4 + 3][3:1];
                end
        endcase
        case(Instr_IU_OC[28:16])
            3'b000: begin
                bankid_b <= LUT[HWWarp_IU_OC * 4][0] << 1;
                rowid_b <= LUT[HWWarp_IU_OC * 4][3:1];
                end
            3'b001: begin
                bankid_b <= LUT[HWWarp_IU_OC * 4][0] << 1 + 1;
                rowid_b <= LUT[HWWarp_IU_OC * 4][3:1];
                end
            3'b010: begin
                bankid_b <= LUT[HWWarp_IU_OC * 4 + 1][0] << 1;
                rowid_b <= LUT[HWWarp_IU_OC * 4 + 1][3:1];
                end
            3'b011: begin
                bankid_b <= LUT[HWWarp_IU_OC * 4 + 1][0] << 1 + 1;
                rowid_b <= LUT[HWWarp_IU_OC * 4 + 1][3:1];
                end
            3'b100: begin
                bankid_b <= LUT[HWWarp_IU_OC * 4 + 2][0] << 1;
                rowid_b <= LUT[HWWarp_IU_OC * 4 + 2][3:1];
                end
            3'b101: begin
                bankid_b <= LUT[HWWarp_IU_OC * 4 + 2][0] << 1 + 1;
                rowid_b <= LUT[HWWarp_IU_OC * 4 + 2][3:1];
                end
            3'b110: begin
                bankid_b <= LUT[HWWarp_IU_OC * 4 + 3][0] << 1 ;
                rowid_b <= LUT[HWWarp_IU_OC * 4 + 3][3:1];
                end
            3'b111: begin
                bankid_b <= LUT[HWWarp_IU_OC * 4 + 3][0] << 1 + 1;
                rowid_b <= LUT[HWWarp_IU_OC * 4 + 3][3:1];
                end
        endcase
    end
end
endmodule