module CDB(
    input wire [2:0] WarpID_ALU_CDB, 
    input wire RegWrite_ALU_CDB,
    input wire [4:0] Dst_ALU_CDB,
    input wire [255:0] Dst_Data_ALU_CDB,

    input wire [2:0] WarpID_MEM_CDB, 
    input wire RegWrite_MEM_CDB,
    input wire [4:0] Dst_MEM_CDB,
    input wire [255:0] Dst_Data_MEM_CDB,

    input wire [31:0] Instr_ALU_CDB,
    input wire ActiveMask_ALU_CDB,

    input wire [31:0] Instr_MEM_CDB,
    input wire ActiveMask_MEM_CDB,

    output wire RegWrite_CDB_RAU,
    output reg [2:0] WriteAddr_CDB_RAU,
    output reg [2:0] HWWarp_CDB_RAU,
    output reg [255:0] Data_CDB_RAU,
    output reg [31:0] Instr_CDB_RAU
);

assign RegWrite_CDB_RAU = RegWrite_ALU_CDB & RegWrite_MEM_CDB;

always @ (*)
begin
    if (RegWrite_ALU_CDB == 1)
    begin
        WriteAddr_CDB_RAU = Dst_ALU_CDB[2:0];
        HWWarp_CDB_RAU = WarpID_ALU_CDB;
        Data_CDB_RAU = Dst_Data_ALU_CDB;
        Instr_CDB_RAU = Instr_ALU_CDB;
    end
    else if (RegWrite_MEM_CDB == 1)
    begin
        WriteAddr_CDB_RAU = Dst_MEM_CDB[2:0];
        HWWarp_CDB_RAU = WarpID_MEM_CDB;
        Data_CDB_RAU = Dst_Data_MEM_CDB;
        Instr_CDB_RAU = Instr_MEM_CDB;
    end
end

endmodule




