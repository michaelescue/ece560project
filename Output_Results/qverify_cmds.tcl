# do qs_files/directives.tcl
netlist clock CLK -period 10
formal netlist constraint RES 1'b0
formal netlist constraint HLT 1'b0
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
# end do qs_files/directives.tcl
formal compile -d darkriscv -cuname my_bind_sva -target_cover_statements
formal verify -init qs_files/myinit.init -timeout 5m
