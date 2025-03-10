module debounce(
    input clock,//100MHz clock
    input reset,
    input enable,
    input [4:0] button,//Buttons to debounce
    output reg [4:0] out
);

reg [18:0] cnt0=0, cnt1=0, cnt2=0, cnt3=0, cnt4=0;
reg [4:0] IV = 0;

//parameter dbTime = 500000;
parameter dbTime = 10;

always @ (posedge(clock))begin
    if(reset==1)begin
        cnt0<=0;
        cnt1<=0;
        cnt2<=0;
        cnt3<=0;
        cnt4<=0;
        out<=0;
    end
    else if(enable) begin
        if(button[0]==IV[0]) begin 
            if (cnt0==dbTime) begin
                out[0]<=IV[0];
                end
            else begin
                cnt0<=cnt0+1;
                end
        end
        else begin
            cnt0<=0;
            IV[0]<=button[0];
            end
        if(button[1]==IV[1]) begin 
            if (cnt1==dbTime) begin
                out[1]<=IV[1];
            end
            else begin
                cnt1<=cnt1+1;
            end
        end
        else begin
            cnt1<=0;
            IV[1]<=button[1];
        end
        if(button[2]==IV[2]) begin 
            if (cnt2==dbTime) begin
                out[2]<=IV[2];
            end
            else begin
                cnt2<=cnt2+1;
            end
        end
        else begin
            cnt2<=0;
            IV[2]<=button[2];
        end
        if(button[3]==IV[3]) begin 
            if (cnt3==dbTime) begin
                out[3]<=IV[3];
            end
            else begin
                cnt3<=cnt3+1;
            end
        end
        else begin
            cnt3<=0;
            IV[3]<=button[3];
        end
        if(button[4]==IV[4]) begin 
            if (cnt4==dbTime) begin
                out[4]<=IV[4];
                end
            else begin
                cnt4<=cnt4+1;
                end
        end
        else begin
            cnt4<=0;
            IV[4]<=button[4];
            end
        end else begin
            out <= button;
        end
end
endmodule

