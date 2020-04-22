//-----------------------------------------------------------------------------------
// Author: You Kejian
// Date:   2019/10/15
// Description:
//      1. Counter transfer through asynchonous clock domain with gray code
//      2. Total latency of 5 cycles
//-----------------------------------------------------------------------------------

module counter_async_with_gray #(
//-----------------------------------------------------------------------------------
//  Parameter Definition
//-----------------------------------------------------------------------------------
    parameter   DWIDTH                                      = 8                     , 
    parameter   U_DLY                                       = 1                     
) (
//-----------------------------------------------------------------------------------
//  Port Definition
//-----------------------------------------------------------------------------------
    input                                           i_clk_a                         ,
    input                                           i_rst_a_n                       ,
    input                                           i_clk_b                         ,
    input                                           i_rst_b_n                       ,

    input       [DWIDTH                 - 1 : 0]    i_input                         ,
    output  reg [DWIDTH                 - 1 : 0]    o_output                        
) ;
//-----------------------------------------------------------------------------------
//  Signal Definition
//-----------------------------------------------------------------------------------
reg     [DWIDTH                         - 1 : 0]    r_input_gray_aclk               ;   // input counter translate to gray code in a clock domain
reg     [DWIDTH                         - 1 : 0]    r_input_gray_bclk               ;   // input counter in b clock domain
reg     [DWIDTH                         - 1 : 0]    r_input_gray_bclk_ff1           ;
reg     [DWIDTH                         - 1 : 0]    r_input_gray_bclk_ff2           ;
//-----------------------------------------------------------------------------------
//  Main function
//-----------------------------------------------------------------------------------
always @(posedge i_clk_a or negedge i_rst_a_n)
begin
    if (i_rst_a_n == 1'b0)
    begin
        r_input_gray_aclk <= {DWIDTH{1'b0}} ;
    end
    else
    begin
        r_input_gray_aclk <= #U_DLY bin2gray(i_input) ;
    end
end

always @(posedge i_clk_b or negedge i_rst_b_n)
begin
    if (i_rst_b_n == 1'b0)
    begin
        r_input_gray_bclk <= {DWIDTH{1'b0}} ;
    end
    else
    begin
        r_input_gray_bclk <= #U_DLY r_input_gray_aclk ;
    end
end

always @(posedge i_clk_b or negedge i_rst_b_n)
begin
    if (i_rst_b_n == 1'b0)
    begin
        r_input_gray_bclk_ff1 <= {DWIDTH{1'b0}} ;
        r_input_gray_bclk_ff2 <= {DWIDTH{1'b0}} ;
    end
    else
    begin
        r_input_gray_bclk_ff1 <= #U_DLY r_input_gray_bclk       ;
        r_input_gray_bclk_ff2 <= #U_DLY r_input_gray_bclk_ff1   ;
    end
end

always @(posedge i_clk_b or negedge i_rst_b_n)
begin
    if (i_rst_b_n == 1'b0)
    begin
        o_output <= {DWIDTH{1'b0}};
    end
    else
    begin
        o_output <= #U_DLY gray2bin(r_input_gray_bclk_ff2);
    end
end
//-----------------------------------------------------------------------------------
//  Function Definition
//-----------------------------------------------------------------------------------
function [DWIDTH-1 : 0] bin2gray;
    input [DWIDTH-1 : 0] bin ;
    integer i;
    begin
        bin2gray[DWIDTH-1] = bin[DWIDTH-1] ;
        for (i=DWIDTH-1; i>0; i=i-1)
        begin
            bin2gray[i-1] = bin[i] ^ bin[i-1] ;
        end
    end
endfunction

function [DWIDTH-1 : 0] gray2bin;
    input [DWIDTH-1 : 0] gray ;
    integer i ;
    begin
        gray2bin[DWIDTH-1] = gray[DWIDTH-1] ;
        for (i=DWIDTH-1; i>0; i=i-1)
        begin
            gray2bin[i-1] = gray2bin[i] ^ gray[i-1] ;
        end
    end
endfunction

endmodule
