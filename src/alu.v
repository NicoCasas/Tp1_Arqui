`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2023 22:46:18
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu
#(
    parameter       NB_DATA =   8,
    parameter       NB_OP   =   6
)
(
    input   wire    [NB_DATA-1:0]   i_data_a,
    input   wire    [NB_DATA-1:0]   i_data_b,
    
    input   wire    [NB_OP  -1:0]   i_op    ,
    
    output  wire    [NB_DATA-1:0]   o_result//,
    //output  wire                    o_carry
);

localparam  op_add  =   6'b100_000;
localparam  op_sub  =   6'b100_010;
localparam  op_and  =   6'b100_100;
localparam  op_or   =   6'b100_101;
localparam  op_xor  =   6'b100_110;
localparam  op_sra  =   6'b000_011;
localparam  op_srl  =   6'b000_010;
localparam  op_nor  =   6'b100_111;

reg [NB_DATA:0] resultado;

always @(*) begin
    case(i_op)
        op_add: resultado =   i_data_a + i_data_b;
        op_sub: resultado =   i_data_a - i_data_b;
        op_and: resultado =   i_data_a & i_data_b;
        op_or : resultado =   i_data_a | i_data_b;
        op_xor: resultado =   i_data_a ^ i_data_b;
        op_sra: resultado = $signed(i_data_a) >>> i_data_b;
        op_srl: resultado =   i_data_a >> i_data_b;
        op_nor: resultado = ~(i_data_a | i_data_b);
        default:resultado = {NB_DATA{1'b0}};
    endcase
end

assign o_result     = resultado[NB_DATA-1:0];
//assign o_carry      = resultado[NB_DATA]; 

endmodule