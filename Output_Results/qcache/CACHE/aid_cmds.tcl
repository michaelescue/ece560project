# 
# Questa Static Verification System
# Version 10.7b linux_x86_64 12 Jun 2018

clear settings -all
clear directives
netlist clock CLK -period 10 
formal netlist constraint RES 1'b0 
formal netlist constraint HLT 1'b0 
formal compile -d darkriscv -cuname my_bind_sva -tcs
formal verify  -init  $env(SRC_ROOT)//u/mescue/darkriscv/qs_files/myinit.init -timeout 5m
