`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2023 23:35:29
// Design Name: 
// Module Name: top
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


module top
#(
    //PARAMETERS
    parameter   NB_DATA = 8,
    parameter   NB_OP   = 6
)
(
    //INPUTS
    input   wire    [NB_DATA-1:0]   i_data          ,
    input   wire                    i_A_button      ,
    input   wire                    i_B_button      ,
    input   wire                    i_OP_button     ,
    
    input   wire                    i_clk           ,
    input   wire                    i_reset         ,
    
    //OUTPUTS
    output  wire    [NB_DATA-1:0]   o_result        ,
    output  wire                    o_locked     
    
);

// CLK
wire clk;
wire reset;

clk_wiz_0 inst
  (
  // Clock out ports  
  .clk(clk),
  // Status and control signals               
  .reset(i_reset), 
  .locked(locked),
 // Clock in ports
  .i_clk(i_clk)
  );

assign reset = i_reset | (~locked);
assign o_locked = locked;

//WIRES DEFINITION
wire [NB_DATA-1:0]  result_alu  ;
//wire                carry_alu   ;
//REGS DEFINITION
reg [NB_DATA-1:0]   result_reg  ;
//reg                 carry_reg   ;
reg [NB_DATA-1:0]   data_A      ;
reg [NB_DATA-1:0]   data_B      ;
reg [NB_OP  -1:0]   data_op     ;

//COMBINATIONAL LOGIC

//SECUENTIAL LOGIC
always @(posedge clk)
begin
    if(reset) 
    begin
        data_A  <= {NB_DATA{1'b0}};
        data_B  <= {NB_DATA{1'b0}};
        data_op <= {NB_OP  {1'b0}};
    end
    else begin
        if(i_A_button) begin
            data_A  <=  i_data;
        end
        if(i_B_button) begin
            data_B  <=  i_data;
        end
        if(i_OP_button) begin
            data_op <=  i_data[NB_OP-1:0];
        end
    end
end

//REGISTER OUTPUTS
always @(posedge clk) begin
    if(reset) 
    begin
        result_reg  <= {NB_DATA{1'b0}};
        //carry_reg   <= 1'b0;
    end
    else 
    begin
        result_reg  <=  result_alu  ;
        //carry_reg   <=  carry_alu   ;
    end
end

//OUTPUT ASSIGN
assign o_result = result_reg    ;
//assign o_carry  = carry_reg     ;

alu #(
    .NB_DATA(NB_DATA)   ,
    .NB_OP  (NB_OP)    
)u_alu
(
    .i_data_a   (data_A)        ,
    .i_data_b   (data_B)        ,
    .i_op       (data_op)       ,
    
    .o_result   (result_alu)    //,
    //.o_carry    (carry_alu)
);

endmodule
