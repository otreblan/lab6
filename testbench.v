// vim: set expandtab:

module testbench;
    reg clk;
    reg reset;
    wire [31:0] WriteData;
    wire [31:0] DataAdr;
    wire MemWrite;
    top dut(
        .clk(clk),
        .reset(reset),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .MemWrite(MemWrite)
    );
    initial begin
        reset <= 1;
        #(10)
            ;
        reset <= 0;
    end
    always begin
        clk <= 1;
        #(5)
            ;
        clk <= 0;
        #(5)
            ;
    end
    always @(negedge clk) begin
        $display("%h %h %h %h", dut.PC, DataAdr, dut.arm.dp.ReadData, dut.MemWrite);

        if (MemWrite)
            if ((DataAdr === 128) & (WriteData === 254)) begin
                $display("Simulation succeeded");
                $finish;
            end
        if (^dut.Instr === 1'bx) begin
            $fatal(1, "Simulation failed");
            $stop;
        end

    end
    initial begin
        $dumpfile("arm_single.vcd");
        $dumpvars;
    end
endmodule
