# do qs_files/directives.tcl
netlist clock CLK -period 10
formal netlist constraint RES 1'b0
formal netlist constraint HLT 1'b0
# end do qs_files/directives.tcl
formal compile -d darkriscv -cuname my_bind_sva -target_cover_statements
formal verify -init qs_files/myinit.init -timeout 5m
