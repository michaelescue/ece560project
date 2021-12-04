onerror resume
wave tags ZIN1 
wave update off
wave add darkriscv.qft_cycle_index -tag ZIN1 -label {cycle} -radix decimal -representation twoscomplement -foregroundcolor Gold
wave group {Primary Clocks} -backgroundcolor #004466
wave add -group {Primary Clocks} darkriscv.CLK -tag ZIN1 -radix binary
wave insertion [expr [wave index insertpoint] + 1]
wave group {Property Signals} -backgroundcolor #006666
wave add -group {Property Signals} darkriscv.mychecker.CLK -tag ZIN1 -radix binary
wave add -group {Property Signals} darkriscv.mychecker.IDATA -tag ZIN1 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group {Control Point Signals} -backgroundcolor #216600
wave add -group {Control Point Signals} darkriscv.IDATA -tag ZIN1 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave add darkriscv.mychecker.OPS -tag ZIN1 -radix binary -select
wave marker add Start 10 LimeGreen
wave marker add Cover 20 Orange
wave update on
