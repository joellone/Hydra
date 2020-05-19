module clk_gen#(
    parameter                                   CLK_PERIOD                  = 6              
)
(
    output  reg                                         o_clk                               ,
    output  reg                                         o_rst_n                              
);

initial
begin
    o_clk   = 1'b0 ;
    o_rst_n = 1'b0 ;

    #(100*CLK_PERIOD)
    o_rst_n = 1'b1 ;
end

always #(CLK_PERIOD/2) o_clk = ~o_clk ;

endmodule
