onerror {exit -code 1}
vlib work
vlog -work work assignment1q7.vo
vlog -work work assignment1q7.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.assignment1q7_vlg_vec_tst -voptargs="+acc"
vcd file -direction assignment1q7.msim.vcd
vcd add -internal assignment1q7_vlg_vec_tst/*
vcd add -internal assignment1q7_vlg_vec_tst/i1/*
run -all
quit -f
