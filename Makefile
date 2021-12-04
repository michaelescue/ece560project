#
# Copyright (c) 2018, Marcelo Samsoniuk
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# 
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
#
# ===8<--------------------------------------------------------- cut here!
#
# This the root makefile and the function of this file is call other
# makefiles. Of course, you need first set the GCC compiler path/name, the
# simulator path/name and the board model in the respective directories:
#
# - src/Makefile
# - sim/Makefile
# - board/Makefile
#
# After configure each Makefile, you can just type 'make'

default: valid

# Added by ME 11/07/21
valid: clean compile formal debug

all:
	make -C src all
	make -C sim all
	make -C boards all

install:
	make -C boards install

clean:
	make -C src clean
	make -C sim clean
	make -C boards clean
	
# Added by ME 11/07/21
compile:
	vlib work
	vmap work work
	vlog rtl/darkriscv.v
	vlog -sv -mfcu -cuname my_bind_sva \
		./src/sva/sva_bind.sv ./src/sva/sva_darkriscv.sv

# Checked file names to this point 11/07/21
# Updated source file path to "rtl/darkriscv.v"
# Updated bind file path to "./src/sva/sva_bind.sv"
# Updated checker file path to "./src/sva/sva_darkriscv.sv"

formal:
	qverify -c -od Output_Results -do "\
		do qs_files/directives.tcl; \
		formal compile -d darkriscv -cuname my_bind_sva \
			-target_cover_statements; \
		formal verify -init qs_files/myinit.init \
		-timeout 5m; \
		exit"
		
#Checked file names to this point 11/08/21
# Updated checker instance name to "darkrsicv"

debug: 
	qverify Output_Results/formal_verify.db &

clean:
	qverify_clean
	\rm -rf work modelsim.ini *.wlf *.log replay* transcript *.db
	\rm -rf Output_Results *.tcl 
