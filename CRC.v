module crc(
	input [7:0] data_in,
	output [3:0] crc_out);
	reg [3:0] crc_out;
	always @(*) begin
		crc_out[0]=data_in[7] ^data_in[3] ^data_in[1] ^data_in[0] ;  
		crc_out[1]=data_in[4] ^data_in[2] ^data_in[1] ;  
		crc_out[2]=data_in[7] ^data_in[5] ^data_in[2] ^data_in[1] ^data_in[0] ;  
		crc_out[3]=data_in[7] ^data_in[6] ^data_in[2] ^data_in[0] ;  
		end // always
endmodule // crc
