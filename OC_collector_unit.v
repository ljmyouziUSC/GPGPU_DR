module OC_collector_unit 
#(
parameter ocid = 0
)
(
WE, RE, valid, bypass_pyld_in,
c_0_reg_id_in,c_1_reg_id_in,
bk_0_data, bk_0_vld, bk_0_ocid, bk_0_bz,
bk_1_data, bk_1_vld, bk_1_ocid, bk_1_bz,
bk_2_data, bk_2_vld, bk_2_ocid, bk_2_bz,
bk_3_data, bk_3_vld, bk_3_ocid, bk_3_bz,
clk,rst, // inputs
RDY, bypass_pyld, oc_0_data, oc_1_data   //outputs
);
	//"WE" is the WE from upstream (2-bit)
	//"RE" means downstream is going to read
	//"RDY" means operand collected
	//"c_0_reg_id_in" src 0 id 
	//"c_1_reg_id_in" src 1 id 
	//"bypass_pyld_in" instruction type & by pass data 
	
input 	[31:0] bk_0_data, bk_1_data, bk_2_data,bk_3_data;
input	bk_0_vld, bk_0_ocid, bk_0_bz,
		bk_1_vld, bk_1_ocid, bk_1_bz,
		bk_2_vld, bk_2_ocid, bk_2_bz,
		bk_3_vld, bk_3_ocid, bk_3_bz;
input [4:0] c_0_reg_id_in, c_1_reg_id_in;
input [1:0] WE;
input RE, clk, rst;
input [10:0] bypass_pyld_in;
output RDY, valid;
output [10:0] bypass_pyld;
output [31:0] oc_0_data;
output [31:0] oc_1_data;
/*---------wire/reg-------*/
wire RDY;
reg valid;
reg [10:0] bypass_pyld;
reg [4:0] oc_0_reg_id;
reg [4:0] oc_1_reg_id;
reg oc_0_valid;
reg oc_1_valid;
reg oc_0_rdy;
reg oc_1_rdy;
reg [31:0] oc_0_data;
reg [31:0] oc_1_data;
/*-------------------------*/

reg [31:0] oc_0_data_in;
reg [31:0] oc_1_data_in;

wire OC_0_WE;
wire OC_1_WE;

assign RDY = valid && ~(oc_0_valid && ~oc_0_rdy) && ~(oc_1_valid && ~oc_1_rdy);

assign OC_0_WE = ((bk_0_ocid == ocid << 1) &&  !bk_0_bz && bk_0_vld)|| 
				 ((bk_1_ocid == ocid << 1) &&  !bk_1_bz && bk_1_vld)|| 
				 ((bk_2_ocid == ocid << 1) &&  !bk_2_bz && bk_2_vld)|| 
				 ((bk_3_ocid == ocid << 1) &&  !bk_3_bz && bk_3_vld);
assign OC_1_WE = ((bk_0_ocid == ocid << 1 + 1) &&  !bk_0_bz && bk_0_vld)|| 
				 ((bk_1_ocid == ocid << 1 + 1) &&  !bk_1_bz && bk_1_vld)|| 
				 ((bk_2_ocid == ocid << 1 + 1) &&  !bk_2_bz && bk_2_vld)|| 
				 ((bk_3_ocid == ocid << 1 + 1) &&  !bk_3_bz && bk_3_vld);
always @ *
begin 
	case (oc_0_reg_id[4:3])
		2'b00:  oc_0_data_in = bk_0_data;
		2'b01:	oc_0_data_in = bk_1_data;
		2'b10:	oc_0_data_in = bk_2_data;
		2'b11:	oc_0_data_in = bk_3_data;
		default: oc_0_data_in = 32'bz;
	endcase
	case (oc_1_reg_id[4:3])
		2'b00:  oc_1_data_in = bk_0_data;
		2'b01:	oc_1_data_in = bk_1_data;
		2'b10:	oc_1_data_in = bk_2_data;
		2'b11:	oc_1_data_in = bk_3_data;
		default: oc_1_data_in = 32'bz;
	endcase
end

always @ (posedge clk or posedge rst)
begin
	if (rst)
		begin
			valid <= 0;
			oc_0_valid <= 0;
			oc_1_valid <= 0;
		end
	else 
		begin
			if (WE != 2'b00)
			begin
				valid <= 1;
				oc_0_rdy <= 0;
				oc_1_rdy <= 0;
				bypass_pyld <= bypass_pyld_in;
				if (WE[0] == 1)
				begin
					oc_0_valid <= 1;
					oc_0_reg_id <= c_0_reg_id_in;
				end
				if (WE[1] == 1)
				begin
					oc_1_valid <= 1;
					oc_1_reg_id <= c_1_reg_id_in;
				end				
			end
			else if (RE == 1)
			begin
				valid <= 0;
				oc_0_valid <= 0;
				oc_1_valid <= 0;
			end
			else 
			begin
				if (oc_0_valid && OC_0_WE)
				begin
					oc_0_data <= oc_0_data_in;
					oc_0_rdy <= 1;
				end
				if (oc_1_valid && OC_1_WE)
				begin
					oc_1_data <= oc_1_data_in;
					oc_1_rdy <= 1;
				end
			end
		end
end

endmodule //OC_collector_unit