module RFOC_Interface
(
    input wire rst,
    input wire clk,

    input wire [31:0] Instr_IU_OC,
    input wire [2:0] ExitWarpID_IB_RAU,
    input wire ExitEN_IB_RAU,
    input wire [2:0] HWWarp_TM_RAU, 
    input wire AlloEN_TM_RAU,
    input wire [2:0] Nreq_TM_RAU,
    input wire SWWarp_TM_RAU, //是多少bit？
    input wire Valid_CDB_ReqFIFO,
    input wire RegWrite_CDB_ReqFIFO,
    input wire [7:0] CDB_RF_WriteAddr,

    output reg Available_RAU_TM,
    output reg AlloStall_RAU_IB,
    
    output reg [31:0] Instr_OC_EX,

    output reg [31:0] Data1_OC_EX,
    output reg Valid1_OC_EX,
    output reg [31:0] Data2_OC_EX,
    output reg Valid2_OC_EX
);