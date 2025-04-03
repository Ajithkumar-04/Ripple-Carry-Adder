`timescale 1ns / 1ps


module rippe_adder(X, Y, S, Co,clk);
 input [3:0] X, Y;// Two 4-bit inputs
 input clk;
 output [3:0]S;
 output Co;
 wire w1, w2, w3;
 wire S0,S1,S2;
 reg X1S1,Y1S1,X2S1,Y2S1,X3S1,Y3S1,X2S2,Y2S2,X3S2,Y3S2,X3S3,Y3S3;
 reg w1S1,s0S1,s0S2,w2S2,s1S2,w3S3,s0S3,s1S3,s2S3;
 

 // instantiating 4 1-bit full adders in Verilog
 fulladder u1(X[0], Y[0], 1'b0, S0, w1,clk); 
 //level 1
  always @(posedge clk)
   begin
   X1S1<=X[1];
   Y1S1<=Y[1];
   X2S1<=X[2];
   Y2S1<=Y[2];
   X3S1<=X[3];
   Y3S1<=Y[3];
   w1S1<=w1;
   s0S1<=S0;
   end
  // assign S[0]=s0S1;
 
 
 fulladder u2(X1S1, Y1S1, w1S1, S1, w2,clk);
 //level 2
  always @(posedge clk)
   begin
   X2S2<=X2S1;
   Y2S2<=Y2S1;
   X3S2<=X3S1;
   Y3S2<=Y3S1;   
   w2S2<=w2;
   s0S2<=s0S1;
   s1S2<=S1;
   end
   assign S[0]=s0S2;
   assign S[1]=s1S2; 
 
 fulladder u3( X2S2, Y2S2, w2S2, S[2], w3,clk);
 fulladder u4(X3S2, Y3S2, w3, S[3], Co,clk);
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


