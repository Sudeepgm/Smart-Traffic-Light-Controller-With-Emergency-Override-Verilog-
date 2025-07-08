module traffic_light_controller (
    input clk,
    input rst,
    input emergency,
    output reg [2:0] main_rd,
    output reg [2:0] side_rd
);
    typedef enum reg [1:0] {IDLE, MAIN_GREEN, MAIN_YELLOW, SIDE_GREEN, SIDE_YELLOW} state_t;
    state_t state;
    reg [3:0] timer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= MAIN_GREEN;
            timer <= 0;
        end else begin
            case (state)
                MAIN_GREEN: begin
                    if (emergency)
                        state <= MAIN_GREEN;
                    else if (timer == 9) begin
                        state <= MAIN_YELLOW;
                        timer <= 0;
                    end else timer <= timer + 1;
                end
                MAIN_YELLOW: begin
                    if (timer == 3) begin
                        state <= SIDE_GREEN;
                        timer <= 0;
                    end else timer <= timer + 1;
                end
                SIDE_GREEN: begin
                    if (timer == 6) begin
                        state <= SIDE_YELLOW;
                        timer <= 0;
                    end else timer <= timer + 1;
                end
                SIDE_YELLOW: begin
                    if (timer == 3) begin
                        state <= MAIN_GREEN;
                        timer <= 0;
                    end else timer <= timer + 1;
                end
            endcase
        end
    end

    always @(*) begin
        main_rd = 3'b100;
        side_rd = 3'b100;
        case (state)
            MAIN_GREEN:  begin main_rd = 3'b001; side_rd = 3'b100; end
            MAIN_YELLOW: begin main_rd = 3'b010; side_rd = 3'b100; end
            SIDE_GREEN:  begin main_rd = 3'b100; side_rd = 3'b001; end
            SIDE_YELLOW: begin main_rd = 3'b100; side_rd = 3'b010; end
        endcase
    end
endmodule