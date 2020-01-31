//components:       FSM;
//                  Lookup Table;
//                  Mapping Table;

//inputs:   From TM:Allocation Enable;
//                  Allocation Numbers;
//                  SWWarpID;
//                  HWWarpID;
//          From IB:Exit Enable;
//                  Exit Warp ID

//outputs:  To TM:  Available Numbers;

//internal signals: 


module RAU 
(
    input wire rst,
    input wire clk,

    input wire IB_Exit_WarpID,
    input wire IB_RAU_ExitEN,
    input wire TM_RAU_HWWarp,
    input wire TM_RAU_AlloEN,
    input wire TM_RAU_Nreq,
    input wire TM_RAU_SWWarp,

    output reg RAU_TM_Available,
)

reg [2:0] state;
reg [2:0] next_state;
wire IB_RAU_ExitEN;
wire TM_RAU_AlloEN;
wire [2:0] IB_Exit_WarpID;
wire [2:0] TM_RAU_HWWarp;
wire [2:0] TM_RAU_Nreq;

reg [2:0] Nreq;
reg [2:0] HWWarp;
reg [4:0] LUT_StartAddr;
reg [2:0] LUT_RF_Row;
reg LUT_RF_Bank;
reg [3:0] MTptr;
reg [4:0] RAU_TM_Available;
reg [31:0] SpecialReg[7:0]; //special register file


localparam READY  = 3'b001;
localparam ALLO   = 3'b010；
localparam DEALLO = 3'b100;


//FSM
//state changing
always @ (posedge clk)
begin
    if (rst == 1'b0) begin
        state <= READY;
    end else begin
        state <= next_state;
    end
end

//conditions
always @ (state or TM_RAU_AlloEN or IB_RAU_ExitEN or Req_Done)    
begin
    case(state)
        READY: begin 
            if (!IB_RAU_ExitEN & TM_RAU_AlloEN) begin
                next_state = ALLO;
            end else if (IB_RAU_ExitEN) begin
                next_state = DEALLO;
            end else begin
                next_state = READY;
            end
        end
        ALLO:begin
            if (Req_Done == 1'b1) begin //defined in next always block
                next_state = READY;
            end else begin
                next_state = ALLO;
            end
        end
        DEALLO:begin
            next_state = READY;
        end
    endcase
end

//Output
always @ (state or TM_RAU_Nreq or TM_RAU_HWWarp or MTptr or posedge clk)
begin
    if (rst == 1'b0) begin
        Nreq <= 0;
        HWWarp <= 0;
        LUT_StartAddr <= 0;
        LUT_RF_Bank <= 0;
        LUT_RF_Row <= 0;
        MTptr <= 0;
        RAU_TM_Available <= 0;
    end else begin


    case(state)
        READY: begin
            if (TM_RAU_AlloEN) begin
                Nreq <= TM_RAU_Nreq;
                HWWarp <= TM_RAU_HWWarp; //SWWARP
                SpecialReg[TM_RAU_HWWarp] <= TM_RAU_SWWarp; // special reg
            end else begin
                HWWarp <= IB_Exit_WarpID; //how to write certain bits in instrcution
            end
        end

        ALLO: begin // regular and special
            LUT_StartAddr = HWWarp * 4;  //LUT starting Addr (Row)
            LUT_RF_Row = MTptr / 2;
            LUT_RF_Bank = MTptr % 2; // gets the mapping of register
                                    //LUT defined as consequtive registers
            MTptr <= MTptr + 1;
            if (Nreq != 0) begin
                for (LUT_Addr <= LUT_StartAddr; MT[MTptr] == 1'b0; LUT_Addr <= LUT_Addr + 1) begin //for loop statement
                    Nreq <= Nreq - 2;
                    LUT[LUT_StartAddr] <= (1'b1, LUT_RF_Row, LUT_RF_Bank);
                    LUT_StartAddr <= LUT_StartAddr + 1;
                    RAU_TM_Available <= RAU_TM_Available - 2;
                    Req_Done = 1'b0;
                end
            end else begin
                Req_Done = 1'b1;
            end
        end


        DEALLO: begin
            if (LUT[HWWarp * 4] && 5b'10000 == 5b'10000) begin
                MT[LUT[HWWarp * 4][3:1] * 2 + LUT[HWWarp * 4][0]] <= 1'b0;	//MT corresponding bit reset
                LUT[HWWarp * 4][4] <= 1'b0; //LUT valid bit reset
                
            end else if (LUT[HWWarp * 4 + 1] && 5b'10000 == 5b'10000) begin
                MT[LUT[HWWarp * 4 + 1][3:1] * 2 + LUT[HWWarp * 4 + 1][0]] <= 1'b0;
                LUT[HWWarp * 4 + 1][4] <= 1'b0;
                
            end else if (LUT[HWWarp * 4 + 2] && 5b'10000 == 5b'10000) begin
                MT[LUT[HWWarp * 4 + 2][3:1] * 2 + LUT[HWWarp * 4 + 2][0]] <= 1'b0;
                LUT[HWWarp * 4 + 2][4] <= 1'b0;
                
            end else if (LUT[HWWarp * 4 + 3] && 5b'10000 == 5b'10000) begin
                MT[LUT[HWWarp * 4 + 3][3:1] * 2 + LUT[HWWarp * 4 + 3][0]] <= 1'b0;			
                LUT[HWWarp * 4 + 3][4] <= 1'b0;
            end
        end
    endcase
end