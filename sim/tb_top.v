`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2023 12:18:05
// Design Name: 
// Module Name: tb_alu
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


module tb_top;

    localparam   T       =  10      ;
    localparam   NB_DATA =  8       ;
    localparam   NB_OP   =  6       ;
    
    localparam  op_add  =   6'b100_000;
    localparam  op_sub  =   6'b100_010;
    localparam  op_and  =   6'b100_100;
    localparam  op_or   =   6'b100_101;
    localparam  op_xor  =   6'b100_110;
    localparam  op_sra  =   6'b000_011;
    localparam  op_srl  =   6'b000_010;
    localparam  op_nor  =   6'b100_111;
    
    
    reg                 clk         ;
    reg                 reset       ;
    reg  [NB_DATA-1:0]  data        ;
    reg                 A_button    ;
    reg                 B_button    ;
    reg                 OP_button   ;
    
    wire [NB_DATA-1:0]  result      ;
    wire                locked      ;
    
    top
    #(
        .NB_DATA(NB_DATA),
        .NB_OP  (NB_OP)
     )u_top(
        .i_clk      (clk)       ,
        .i_reset    (reset)     ,
        .i_data     (data)      ,
        .i_A_button (A_button)  ,
        .i_B_button (B_button)  ,
        .i_OP_button(OP_button) ,
        
        .o_result   (result)    ,
        .o_locked   (locked)
     );
     
     initial begin
        reset = 1'b1;
        #(T) 
        reset = 1'b0;
     end
     
     initial begin
        clk = 1'b0;
     end
     always begin
        #(T/2) clk = ~clk; 
     end
         
     initial begin
     #T
        while(~locked)begin
        #T
            A_button = 1'b0;
        end
        
        A_button = 1'b0;
        B_button = 1'b0;
        OP_button = 1'b0;
        #(2*T) 
        data = $random();
        A_button = 1'b1;
        #(2*T)
        A_button = 1'b0;
        data = $random();
        B_button = 1'b1;
        #(2*T)
        B_button = 1'b0;
        data = op_add;
        
        #(2*T)
        OP_button = 1'b1;
        #(2*T)
        OP_button = 1'b0;
         
        #(6*T)
        data = op_sub;
        #(2*T)
        OP_button = 1'b1;
        #(2*T)
        OP_button = 1'b0;
        
        #(2*T)
        data = op_sub;
        #(2*T)
        OP_button = 1'b1;
        #(2*T)
        OP_button = 1'b0;
        
        #(2*T)
        data = op_and;
        #(2*T)
        OP_button = 1'b1;
        #(2*T)
        OP_button = 1'b0;
        
        #(2*T)
        data = op_or;
        #(2*T)
        OP_button = 1'b1;
        #(2*T)
        OP_button = 1'b0;
        
        #(2*T)
        data = op_xor;
        #(2*T)
        OP_button = 1'b1;
        #(2*T)
        OP_button = 1'b0;
        
        #(2*T)
        data = op_sra;
        #(2*T)
        OP_button = 1'b1;
        #(2*T)
        OP_button = 1'b0;
        
        #(2*T)
        data = op_srl;
        #(2*T)
        OP_button = 1'b1;
        #(2*T)
        OP_button = 1'b0;
        
        #(2*T)
        data = op_nor;
        #(2*T)
        OP_button = 1'b1;
        #(2*T)
        OP_button = 1'b0;
        
        #(4*T)
        $finish();
     end 
     
     
endmodule
