# Define clocks
netlist clock clk -period 10 

# Constrain rst
formal netlist constraint reset_n 1'b0
