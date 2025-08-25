// Vending Machine :-

`timescale 1ns / 1ps

module VM_design # (
    
    parameter SPRITE_PRICE          = 7'd20,
    parameter PEPSI_PRICE           = 7'd35,
    parameter COCACOLA_PRICE        = 7'd30,
    parameter SLICE_PRICE           = 7'd35,
    parameter MOUNTAIN_DEW_PRICE    = 7'd40
)
(
    //global inputs
    input wire i_clk,   //clock signal
    input wire i_rst,   //reset signal
    
    //inputs
    input wire          i_start,        //start signal
    input wire          i_cancel,       //cancel signal
    input wire [2:0]    i_product,      //product selection
    input wire          i_payment,      //payment (online)
    input wire [2:0]    i_coin_value,   //total value of coin
    
    //output
    output wire [3:0]   o_state,                //current state
    output wire         o_dispense_product,     //dispance product
    output wire [0:6]   o_price,                //price of product
    output wire [0:6]   o_change                //change value to be returned
    
    );

    //ststes (list of progucts in vending machine)
    
    localparam IDEAL_STATE                  = 4'b0000,
               SELECTION_PRODUCT_STATE      = 4'b0001,
               SPRITE_STATE                 = 4'b0010,
               PEPSI_STATE                  = 4'b0011,
               COCACOLA_STATE               = 4'b0100,
               SLICE_STATE                  = 4'b0101,
               MOUNTAIN_DEW_STATE           = 4'b0110,
               DISPENSE_AND_RETURN_STATE    = 4'b0111;
        
    //internal wires and registers
    reg [3:0]   r_state, r_next_state;
    reg [6:0]   r_product_price;
    reg [6:0]   r_product_price_next;
    reg [6:0]   r_return_change;
    reg [6:0]   r_return_change_next;
    reg         r_dispanse_product;
        
    //update state
    always@(posedge i_clk or posedge i_rst) begin
       
       if(i_rst) begin
        
        r_state <= IDEAL_STATE;
        r_product_price <= 0;
        r_return_change <= 0;
        
       end 
       
       else begin
       
        r_state <= r_next_state; 
        r_product_price <= r_product_price_next;
        r_return_change <= r_return_change_next;
       
       end
        
    end
    
    always@(*) begin
    
        r_next_state = r_state;
        r_product_price_next = r_product_price;
        r_return_change_next = r_return_change;
        
        case(r_state)
            
            IDEAL_STATE: begin
                
                if(i_start)
                    r_next_state = SELECTION_PRODUCT_STATE;
                else if(i_cancel)
                    r_next_state = IDEAL_STATE;
                else
                    r_next_state = IDEAL_STATE;
            
            end
            
            SELECTION_PRODUCT_STATE: begin
                case(i_product)
                
                    3'b000: begin
                        r_next_state = SPRITE_STATE;
                        r_product_price_next = SPRITE_PRICE;
                    end
                    
                    3'b001: begin
                        r_next_state = PEPSI_STATE;
                        r_product_price_next = PEPSI_PRICE;
                    end
                    
                    3'b010: begin
                        r_next_state = COCACOLA_STATE;
                        r_product_price_next = COCACOLA_PRICE;
                    end
                    
                    3'b011: begin
                        r_next_state = SLICE_STATE;
                        r_product_price_next = SLICE_PRICE;
                    end
                    
                    3'b100: begin
                        r_next_state = MOUNTAIN_DEW_STATE;
                        r_product_price_next = MOUNTAIN_DEW_PRICE;
                    end
                    
                    default: begin
                        r_next_state = IDEAL_STATE;
                        r_product_price_next = 0;
                    end
                    
                endcase
            
            end
            
            SPRITE_STATE,
            PEPSI_STATE,
            COCACOLA_STATE,
            SLICE_STATE,
            MOUNTAIN_DEW_STATE: begin
            
                if(i_cancel) begin
                    r_next_state = IDEAL_STATE;
                    r_return_change_next = i_coin_value;
                end
                else if(i_coin_value >= r_product_price)
                    r_next_state = DISPENSE_AND_RETURN_STATE;
                else if(i_payment)
                    r_next_state = DISPENSE_AND_RETURN_STATE;
                else
                    r_next_state = r_state;
                           
            end
            
            DISPENSE_AND_RETURN_STATE: begin
            
                r_next_state = IDEAL_STATE;
                if(i_payment)
                    r_return_change_next = 0;
                else if(i_coin_value >= r_product_price)
                    r_return_change_next = i_coin_value - r_product_price;
            
            end
            
            default: begin
            
                r_next_state = IDEAL_STATE;
                r_product_price_next = 0;
                r_product_price_next = 0;
                
            end
            
        endcase
    
    end
    
    //output logic
    
    assign o_state = r_state;
    assign o_dispense_product = (r_state == DISPENSE_AND_RETURN_STATE) ? 1'b1 : 1'b0;
    assign o_change =           (r_state == DISPENSE_AND_RETURN_STATE) ? r_return_change : 1'b0;
    assign o_price =            (r_state == DISPENSE_AND_RETURN_STATE) ? r_product_price : 1'b0;

endmodule
