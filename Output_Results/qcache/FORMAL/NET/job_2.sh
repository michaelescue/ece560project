#! /bin/bash 
/pkgs/mentor/questa_cdc_formal/10.7b/linux_x86_64/bin/qverifypm --monitor --host auto.ece.pdx.edu --port 32883 --wd /u/mescue/darkriscv --type slave --binary /pkgs/mentor/questa_cdc_formal/10.7b/linux_x86_64/bin/qverifyfk --id 2 -netcache /u/mescue/darkriscv/Output_Results/qcache/FORMAL/NET -od Output_Results -tool prove -init qs_files/myinit.init -timeout 5m -import_db Output_Results/formal_compile.db -slave_mode -mpiport 'auto.ece.pdx.edu:39859' -slave_id 1 
