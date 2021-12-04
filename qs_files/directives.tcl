# Define clocks
netlist clock CLK -period 10 

# Constrain rst
formal netlist constraint RES 1'b0

# Constrain hlt
formal netlist constraint HLT 1'b0