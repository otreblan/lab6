default: arm_single.vvp

arm_single.vvp: arm_single.v
	iverilog -o $@ -- $<

arm_single.vvp: $(filter-out arm_single.v, $(wildcard *.v))
