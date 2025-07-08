`timescale 1ns/1ps
module traffic_light_tb;
    reg clk = 0, rst, emergency;
    wire [2:0] main_rd, side_rd;

    traffic_light_controller uut (
        .clk(clk),
        .rst(rst),
        .emergency(emergency),
        .main_rd(main_rd),
        .side_rd(side_rd)
    );

    always #5 clk = ~clk;

    initial begin
        $monitor("Time: %0t | Main: %b | Side: %b | Emergency: %b", $time, main_rd, side_rd, emergency);
        rst = 1; emergency = 0;
        #20 rst = 0;
        #100 emergency = 1;
        #50 emergency = 0;
        #200 $finish;
    end
endmodule