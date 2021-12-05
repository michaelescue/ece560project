# Define clocks
netlist clock CLK -period 10 

# Constrain rst
formal netlist constraint RES 1'b0

# Constrain hlt
formal netlist constraint HLT 1'b0

# Cutpoints
netlist cutpoint uimm -module darkriscv_checker_sva 
netlist cutpoint iimm -module darkriscv_checker_sva 
netlist cutpoint simm1 -module darkriscv_checker_sva 
netlist cutpoint bimm2 -module darkriscv_checker_sva 
netlist cutpoint simm2 -module darkriscv_checker_sva 
netlist cutpoint bimm1 -module darkriscv_checker_sva 
netlist cutpoint bimm3 -module darkriscv_checker_sva
netlist cutpoint rs1 -module darkriscv_checker_sva
netlist cutpoint rs2 -module darkriscv_checker_sva
netlist cutpoint rd -module darkriscv_checker_sva
