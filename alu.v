// vim: set expandtab:
`timescale 1ns/1ns

module alu(a, b, ALUControl, Result, ALUFlags);
    input [31:0] a, b;
    input [2:0] ALUControl;
    // ALUControl  | Operación
    // 000         | ADD
    // 001         | SUB
    // 010         | AND
    // 011         | ORR
    // 100         | EOR

    output [31:0] Result;
    output [3:0] ALUFlags;

    wire N, Z, C, V;
    wire [32:0] sum;

    wire [31:0]_b;
    assign _b = (ALUControl[0]? ~b : b); // Sin _b, el resultado es diferente.
    assign sum = a + _b + ALUControl[0];

    // Usé esto en lugar del switch para que Result no sea un reg.
    assign Result = ALUControl[2]? a^b:
        ALUControl[1]? (ALUControl[0]? (a|b) : (a&b)) : sum;

    assign N = Result[31];
    assign Z = Result == 0;
    and(C, sum[32], ~ALUControl[1]);
    and(V, ~ALUControl[1], sum[31] ^ a[31], ~ALUControl[0] ^ a[31] ^ b[31]);

    assign ALUFlags = {N, Z, C, V};

endmodule
