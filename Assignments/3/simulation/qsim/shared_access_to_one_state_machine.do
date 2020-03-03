onerror {exit -code 1}
vlib work
vlog -work work shared_access_to_one_state_machine.vo
vlog -work work shared_access_to_one_state_machine.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.shared_access_to_one_state_machine_vlg_vec_tst -voptargs="+acc"
vcd file -direction shared_access_to_one_state_machine.msim.vcd
vcd add -internal shared_access_to_one_state_machine_vlg_vec_tst/*
vcd add -internal shared_access_to_one_state_machine_vlg_vec_tst/i1/*
run -all
quit -f
