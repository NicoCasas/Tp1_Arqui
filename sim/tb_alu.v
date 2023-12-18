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


module tb_alu;

    localparam      T = 20;
    localparam      NB_DATA = 8;
    localparam      NB_OP   = 6;
    
    localparam  op_add  =   6'b100_000;
    localparam  op_sub  =   6'b100_010;
    localparam  op_and  =   6'b100_100;
    localparam  op_or   =   6'b100_101;
    localparam  op_xor  =   6'b100_110;
    localparam  op_sra  =   6'b000_011;
    localparam  op_srl  =   6'b000_010;
    localparam  op_nor  =   6'b100_111;
    
    reg [NB_DATA-1:0]       dato_A      ;
    reg [NB_DATA-1:0]       dato_B      ;
    reg [NB_OP  -1:0]       dato_OP     ;
    reg [$clog2(NB_OP)-1:0] dato_OP_idx ;
    wire [NB_DATA-1:0]      resultado   ;
    reg                     assert_flag ;
    
    reg [NB_DATA-1:0]       nxt_dato_A      ;
    reg [NB_DATA-1:0]       nxt_dato_B      ;
    reg [NB_OP  -1:0]       nxt_dato_OP     ;
    reg [$clog2(NB_OP)-1:0] nxt_dato_OP_idx ;
    
    
    wire [$clog2(NB_OP)-1:0]nxt_dato_OP_idx;
    
    reg                 clk;
    
    
    alu #(
        .NB_DATA(NB_DATA),
        .NB_OP(NB_OP)
    )
    u_alu
    (
        .i_data_a(dato_A),
        .i_data_b(dato_B),
        .i_op(dato_OP),
    
        .o_result(resultado)
    );
    
    initial begin
        dato_A      = 0;
        dato_B      = 0;
        dato_OP     = 0;
        dato_OP_idx = 0;
        clk         = 0;
        assert_flag = 0;
    end

    always begin
        #(T/2) clk = ~clk;
    end

    always @(posedge clk) begin        
        dato_A      <= nxt_dato_A;
        dato_B      <= nxt_dato_B;
        dato_OP_idx <= nxt_dato_OP_idx;
        dato_OP     <= nxt_dato_OP;
    end

    always @(*) begin
    nxt_dato_A      = dato_A;
    nxt_dato_B      = dato_B;
    nxt_dato_OP_idx = dato_OP_idx + 1;
    
        if(dato_OP_idx == 0) begin
            nxt_dato_A = $random();
            nxt_dato_B = $random();
        end
        
        //if(dato_OP_idx == 5 || dato_OP_idx == 6) nxt_dato_B = dato_B & 3'b111;
        
    end

    always @(*) begin
        case(dato_OP_idx)
            0: nxt_dato_OP =  op_add ;
            1: nxt_dato_OP =  op_sub ;
            2: nxt_dato_OP =  op_and ;
            3: nxt_dato_OP =  op_or  ;
            4: nxt_dato_OP =  op_xor ;
            5: nxt_dato_OP =  op_sra ;
            6: nxt_dato_OP =  op_srl ;
            7: nxt_dato_OP =  op_nor ;
            default:nxt_dato_OP = {NB_OP{1'b0}};
        endcase
    end

    always @(*) begin
        case(dato_OP)
            op_add: assert_flag = ~(((dato_A + dato_B) & 8'hff) == resultado);
            op_sub: assert_flag = ~(resultado ==   (dato_A - dato_B));
            op_and: assert_flag = ~(resultado ==   (dato_A & dato_B));
            op_or : assert_flag = ~(resultado ==   (dato_A | dato_B));
            op_xor: assert_flag = ~(resultado ==   (dato_A ^ dato_B));
            op_sra: assert_flag = ~($signed(resultado) == ($signed(dato_A) >>> dato_B));
            op_srl: assert_flag = ~(resultado ==   (dato_A >> dato_B));
            op_nor: assert_flag = ~(resultado == (~(dato_A | dato_B)));
            default: assert_flag = {1'b0};
        endcase
    end
    
    always @(posedge clk) begin
        //if(dato_OP == op_sra) $display("%b",($signed(dato_A) >>> dato_B));
        if(assert_flag == 1'b1) begin
            $display("Error");
            $stop;
        end
    end
    
    initial begin
        #(100*T)
        $display("Test OK");
        $finish;
    end

endmodule
