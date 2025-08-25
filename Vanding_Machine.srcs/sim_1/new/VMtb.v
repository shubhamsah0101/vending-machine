`timescale 1ns / 1ps

module VMtb;

    reg CLK;
    reg RST;
    
    //input
    reg START;
    reg CANCEL;
    reg [2:0] PRODUCT;
    reg PAYMENT;
    reg [6:0] COIN;
    
    //output
    wire [3:0] STATE;
    wire DISPENCE;
    wire [0:6] PRICE;
    wire [0:6] CHANGE;
    
    //clock
    
    always begin
    
        #5 CLK = ~CLK;
       
    end
    
    initial begin
    
        CLK = 1'b0;
        RST = 1'b1;
        START = 1'b0;
        CANCEL = 1'b0;
        COIN = 6'b000000;
        PAYMENT = 0;
        PRODUCT = 3'b000;
        
        #100 RST = 1'b0;
        #100;
        
        START = 1'b1;
        PAYMENT = 1'b1;
        #30
        
        START = 1'b0;
        PAYMENT = 1'b0;
        
        #50
        START = 1'b1;
        PRODUCT = 3'b001;   //SPRITE
        COIN = 7'd60;
        START = 1'b0;
        
        #50
        START = 1'b1;
        PRODUCT = 3'b011;   //PEPSI
        COIN = 7'd100;
        START = 1'b0;
        
        #50
        START = 1'b1;
        PRODUCT = 3'b001;   //SPRITE
        COIN = 7'd60;
        START = 1'b0;
        
        #50 $finish;
    
    end
    
    VM_design vm(
        .i_clk(CLK),
        .i_rst(RST),
        
        .i_start(START),
        .i_cancel(CANCEL),
        .i_product(PRODUCT),
        .i_payment(PAYMENT),
        .i_coin_value(COIN),
        
        .o_state(STATE),
        .o_dispense_product(DISPENCE),
        .o_price(PRICE),
        .o_change(CHANGE)
    );

endmodule
