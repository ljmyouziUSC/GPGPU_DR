//ReqFIFO:  O.C:    Warp;      ----fetching data request;
//                  Logic Reg;
//                  O.C ID;
//RF a_wr,b_wr to conrtol read/write; 1->write 0->read;
//          CDB:    RegWrite;   ----Disable FIFO
//Output:   ReadAddr;
//          WriteAddr;

module  RF_Controler
(
    input wire rst,
    input wire clk,

    input wire ReqFIFO_2op_EN,
    input wire [2:0] rowid_a, rowid_b,
    input wire [1:0] ocid,
    input wire CDB_RF_RegWrite,
    input wire CDB_RF_WriteAddr,

    output reg [2:0] RF_Addr,
    output reg [1:0] ocid_out,
    output wire RF_WR,
    output wire bank_valid
);



//定义fifo
reg [4:0] ReqFIFO [2:0];
reg [2:0] Rp, Wp_a, Wp_b;
reg [2:0] depth;




//ReqFIFO

assign RF_WR = CDB_RF_RegWrite;
always @ (posedge clk)
begin
    if (rst == 1'b0) begin
        depth <= 0;
        Rp <= 3'b000;
        Wp_a <= 3'b000;
        Wp_b <= 3'b001;//hold for two source operands falls into same bank;
    end else begin
        if (depth != 3'b111) begin
            if (ReqFIFO_2op_EN == 1) begin
                ReqFIFO[Wp_a] <= {ocid, rowid_a};
                ReqFIFO[Wp_b] <= {ocid, rowid_b};
                Wp_a <= Wp_a + 2;
                Wp_b <= Wp_b + 2;
                depth <= depth + 2;
            end else begin
                ReqFIFO[Wp_a] <= {ocid, rowid_a};//分配到不同的bank
                ReqFIFO[Wp_b] <= {ocid, rowid_b};
                Wp_a <= Wp_a + 1;
                Wp_b <= Wp_b + 1;//覆盖住
                depth <= depth + 1;
            end
        end
        if (depth != 0) begin
            if (RF_WR == 0) begin
                //one more stall
                Rp <= Rp + 1;
                RF_Addr = ReqFIFO[Rp][2:0];
                ocid_out = ReqFIFO[Rp][4:3];
                depth <= depth - 1;
            end else begin
                RF_Addr = CDB_RF_WriteAddr;
            end
        end
    end
end
assign bank_valid = (depth != 0);

endmodule

//check special registers