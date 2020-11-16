// vim: set expandtab:

module decode (
    Op,
    Funct,
    Rd,
    FlagW,
    PCS,
    RegW,
    MemW,
    MemtoReg,
    MemExtend,
    ALUSrc,
    ImmSrc,
    RegSrc,
    ALUControl
);
    input wire [1:0] Op;
    input wire [5:0] Funct;
    input wire [3:0] Rd;
    output reg [1:0] FlagW;
    output wire PCS;
    output wire RegW;
    output wire MemW;
    output wire MemtoReg;
    output wire MemExtend;
    output wire ALUSrc;
    output wire [1:0] ImmSrc;
    output wire [1:0] RegSrc;
    output reg [2:0] ALUControl;
    reg [10:0] controls; // Olvidé aumentar el tamaño
    wire Branch;
    wire ALUOp;
    always @(*)
        casex (Op)
            2'b00: // Alu
                if (Funct[5])
                    controls = 11'b00001001001;
                else
                    controls = 11'b00000001001;
            2'b01: // Memory
                if (Funct[0]) begin
                    if(Funct[3]) // LDRB
                        controls = 11'b00011111000;
                    else // LDR
                        controls = 11'b00011101000;
                end
                else // STR
                    controls = 11'b10011100100;
            2'b10: controls = 11'b01101000010; // B
            default: controls = 11'bxxxxxxxxxxx;
        endcase
    assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, MemExtend, RegW, MemW, Branch, ALUOp} = controls;
    always @(*)
        if (ALUOp) begin
            case (Funct[4:1])
                4'b0100: ALUControl = 3'b000; // ADD
                4'b0010: ALUControl = 3'b001; // SUB
                4'b0000: ALUControl = 3'b010; // AND
                4'b1100: ALUControl = 3'b011; // ORR

                4'b0001: ALUControl = 3'b100; // EOR TODO: Modify ALU

                default: ALUControl = 3'bxx;
            endcase
            FlagW[1] = Funct[0];
            FlagW[0] = Funct[0] & ((ALUControl == 3'b000) | (ALUControl == 3'b001));
        end
        else begin
            ALUControl = 3'b000;
            FlagW = 2'b00;
        end
    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
