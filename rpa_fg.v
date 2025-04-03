`timescale 1ns / 1ps


module rippe_adder(X, Y, S, Co,clk);
 input [3:0] X, Y;// Two 4-bit inputs
 input clk;
 output [3:0]S;
 output Co;
 wire w1, w2, w3;
//reg l1,l2,x1,x2,x3,y1,y2,y3,x31,y31,x21,y21;
//reg [3:0]s0,s1;
 // instantiating 4 1-bit full adders in Verilog
 fulladder u1(X[0], Y[0], 1'b0, S[0], w1,clk); 
 fulladder u2(X[1], Y[1], w1, S[1], w2,clk);
 fulladder u3(X[2], Y[2], w2, S[2], w3,clk);
 fulladder u4(X[3], Y[3], w3, S[3], Co,clk);
endmodule

module fulladder(X, Y, Ci, S, Co,clk);
  input X, Y, Ci,clk;
  output S, Co;
  wire w1,w2,w3;
  reg L1,L2,L3,L4,L5,L6;
  //level 1
xor g1(w1,X,Y);
and g2(w2,X,Y);

always @(posedge clk)
begin
L1<=w1;
L2<=w2;
L3<=Ci;
end

//level 2
xor g3(s,L1,L3);
and g4(w3,L1,L3);

always @(posedge clk)
begin
L4<=L2;
L5<=w3;
L6<=s;
end
assign S=L6;
//level 3
or(Co,L5,L4);

  
 

endmodule


