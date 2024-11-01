/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_c_4_4b_mult(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Partial products
    wire [3:0] pp0, pp1, pp2, pp3;

    // input and output to multiplier
    wire[3:0] q, m;
    wire[7:0] p;

    // Intermediate sums and carries
    wire [3:0] sum1, carry1;
    wire [3:0] sum2, carry2;
    wire [3:0] sum3, carry3;
   
    // splitting up ui_in to q and m
    // ui_in is 8-bits, so splitting into 2 portions of 4-bits each
    assign q = ui_in[7:4];
    assign m = ui_in[3:0];

    // Generate the partial products (AND gates)
    assign pp0 = {4{q[0]}} & m;  // q[0] * m
    assign pp1 = {4{q[1]}} & m;  // q[1] * m
    assign pp2 = {4{q[2]}} & m;  // q[2] * m
    assign pp3 = {4{q[3]}} & m;  // q[3] * m

    // First row: directly assign the least significant bit
    assign p[0] = pp0[0];

    // First stage adders (sum the first two rows)
    full_adder fa1_0(pp0[1], pp1[0], 1'b0, p[1], carry1[0]);
    full_adder fa1_1(pp0[2], pp1[1], carry1[0], sum1[1], carry1[1]);
    full_adder fa1_2(pp0[3], pp1[2], carry1[1], sum1[2], carry1[2]);
    full_adder fa1_3(1'b0, pp1[3], carry1[2], sum1[3], carry1[3]);

    // Second stage adders (sum the results from the first stage with the next row)
    full_adder fa2_0(sum1[1], pp2[0], 1'b0, p[2], carry2[0]);
    full_adder fa2_1(sum1[2], pp2[1], carry2[0], sum2[1], carry2[1]);
    full_adder fa2_2(sum1[3], pp2[2], carry2[1], sum2[2], carry2[2]);
    full_adder fa2_3(carry1[3], pp2[3], carry2[2], sum2[3], carry2[3]);

    // Third stage adders (sum the results from the second stage with the final row)
    full_adder fa3_0(sum2[1], pp3[0], 1'b0, p[3], carry3[0]);
    full_adder fa3_1(sum2[2], pp3[1], carry3[0], p[4], carry3[1]);
    full_adder fa3_2(sum2[3], pp3[2], carry3[1], p[5], carry3[2]);
    full_adder fa3_3(carry2[3], pp3[3], carry3[2], p[6], carry3[3]);
  	
    // Final output bit (MSB of the product)
    assign p[7] = carry3[3];
  
    assign uo_out = p;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n,uio_in, 1'b0};
  assign uio_out = 0;
  assign uio_oe  = 0;

endmodule

module full_adder (Cin, x, y, s, Cout);
     input Cin, x, y;
     output s, Cout;
     wire z1, z2, z3;
     xor (s, x, y, Cin);
     and (z1, x, y);
     and (z2, x, Cin);
     and (z3, y, Cin);
     or (Cout, z1, z2, z3);
endmodule