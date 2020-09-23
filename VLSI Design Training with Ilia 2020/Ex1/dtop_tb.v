`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module dtop_tb();

    // bus sizing:
    localparam scBusSize=37;
    localparam     cntrlBusSize=8;

    reg  [scBusSize-1:0] scin;        
    reg  [cntrlBusSize-1:0] cntrl;
    wire [scBusSize-1:0] scout;        
    
    
    // instantiations of dtop module: 
    dtop UUT(.scin(scin),.cntrl(cntrl),.scout(scout));// by name

    initial begin
            scin=37'd91625968981; cntrl=8'd0;  // initial input values
            $monitor($time,"scin=%h,cntrl=%h,scout=%h",scin,cntrl,scout);// system monitoring function
    end
        
    always begin
        if(cntrl==8'd63) $finish;
        #2;
        cntrl=cntrl+1;
    end


endmodule
