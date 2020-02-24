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

    input wire [2:0] ExitWarpID_IB_RAU,
    input ExitEN_IB_RAU,
    input wire [2:0] HWWarp_TM_RAU, //HWWarp_TM_RAU
    input AlloEN_TM_RAU,
    input wire [2:0] Nreq_TM_RAU,
    input SWWarp_TM_RAU,

    output reg [4:0] Available_RAU_TM,
    output reg Req_Done_RAU_IB//end or start stall
);

reg [2:0] state;
reg [2:0] next_state;
wire ExitEN_IB_RAU;
wire AlloEN_TM_RAU;



reg [2:0] Nreq;
reg [2:0] HWWarp;
reg [4:0] LUT_StartAddr;
reg [4:0] LUT_Addr;

reg [2:0] LUT_RF_Row;
reg LUT_RF_Bank;
reg [3:0] MTptr;
reg [31:0] SpecialReg[7:0]; //special register file

reg MT [15:0];
reg [4:0] LUT [31:0];


localparam READY  = 3'b001;
localparam ALLO   = 3'b010;
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
always @ (state or AlloEN_TM_RAU or ExitEN_IB_RAU or Req_Done_RAU_IB)    
begin
    case(state)
        READY: begin 
            if (!ExitEN_IB_RAU & AlloEN_TM_RAU) begin
                next_state = ALLO;
            end else if (ExitEN_IB_RAU) begin
                next_state = DEALLO;
            end else begin
                next_state = READY;
            end
        end
        ALLO:begin
            if (Req_Done_RAU_IB == 1'b1) begin //defined in next always block
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
always @ (state or Nreq_TM_RAU or HWWarp_TM_RAU or MTptr or posedge clk)
begin
    if (rst == 1'b0) begin
        Nreq <= 0;
        HWWarp <= 0;
        LUT_StartAddr <= 0;
        LUT_RF_Bank <= 0;
        LUT_RF_Row <= 0;
        MTptr <= 0;
        Available_RAU_TM <= 0;
        Req_Done_RAU_IB <= 0;
    end else begin


    case(state)
        READY: begin
            if (AlloEN_TM_RAU) begin
                Nreq <= Nreq_TM_RAU;
                HWWarp <= HWWarp_TM_RAU; //SWWARP
                SpecialReg[HWWarp_TM_RAU] <= SWWarp_TM_RAU; // special reg
            end else begin
                HWWarp <= ExitWarpID_IB_RAU; //how to write certain bits in instrcution
            end
        end

        ALLO: begin // regular and special
            LUT_StartAddr = HWWarp * 4;  //LUT starting Addr (Row)
            LUT_RF_Row = MTptr / 2;
            LUT_RF_Bank = MTptr % 2; // gets the mapping of register
                                    //LUT defined as consequtive registers
            MTptr <= MTptr + 1;
            if (Nreq != 0) begin
                for (LUT_Addr = LUT_StartAddr; MT[MTptr] == 1'b0; LUT_Addr = LUT_Addr + 1) begin //for loop statement//不能用<=??associative？
                    Nreq <= Nreq - 2;
                    LUT[LUT_StartAddr] <= {1'b1, LUT_RF_Row, LUT_RF_Bank};
                    LUT_StartAddr <= LUT_StartAddr + 1;
                    Available_RAU_TM <= Available_RAU_TM - 2;
                    Req_Done_RAU_IB = 1'b0;
                end
            end else begin
                Req_Done_RAU_IB = 1'b1;
            end
        end


        DEALLO: begin
            if (LUT[HWWarp * 4] && 5'b10000 == 5'b10000) begin
                MT[LUT[HWWarp * 4][3:1] * 2 + LUT[HWWarp * 4][0]] <= 1'b0;	//MT corresponding bit reset
                LUT[HWWarp * 4][4] <= 1'b0; //LUT valid bit reset
                Available_RAU_TM <= Available_RAU_TM + 2;
                
            end

            if (LUT[HWWarp * 4 + 1] && 5'b10000 == 5'b10000) begin
                MT[LUT[HWWarp * 4 + 1][3:1] * 2 + LUT[HWWarp * 4 + 1][0]] <= 1'b0;
                LUT[HWWarp * 4 + 1][4] <= 1'b0;
                Available_RAU_TM <= Available_RAU_TM + 4;
                
            end

            if (LUT[HWWarp * 4 + 2] && 5'b10000 == 5'b10000) begin
                MT[LUT[HWWarp * 4 + 2][3:1] * 2 + LUT[HWWarp * 4 + 2][0]] <= 1'b0;
                LUT[HWWarp * 4 + 2][4] <= 1'b0;
                Available_RAU_TM <= Available_RAU_TM + 6;
                
            end
            
            if (LUT[HWWarp * 4 + 3] && 5'b10000 == 5'b10000) begin
                MT[LUT[HWWarp * 4 + 3][3:1] * 2 + LUT[HWWarp * 4 + 3][0]] <= 1'b0;			
                LUT[HWWarp * 4 + 3][4] <= 1'b0;
                Available_RAU_TM <= Available_RAU_TM + 8; // later one will mask the previous ones

            end
        end
    endcase
end
end
endmodule