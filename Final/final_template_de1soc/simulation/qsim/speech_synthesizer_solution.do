onerror {exit -code 1}
vlib work
vlog -work work speech_synthesizer_solution.vo
vlog -work work Light_Control_sim.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.Light_Control_vlg_vec_tst -voptargs="+acc"
vcd file -direction speech_synthesizer_solution.msim.vcd
vcd add -internal Light_Control_vlg_vec_tst/*
vcd add -internal Light_Control_vlg_vec_tst/i1/*
run -all
quit -f
