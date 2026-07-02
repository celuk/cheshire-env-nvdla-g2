open_hw_manager
connect_hw_server

set hw_target [lindex [get_hw_targets] 0]
set_property PARAM.FREQUENCY 5000000 $hw_target

open_hw_target $hw_target

if { $argc > 0 } {
    set bitstream_file [lindex $argv 0]
} else {
    puts "No bitstream file specified, using default."
    set bitstream_file "C:/Users/2640084/Desktop/ubuntu/shared/projects/cheshire-env-nvdla-g2/target/xilinx/build/genesys2.cheshire/cheshire.runs/impl_1/cheshire_top_xilinx.bit"
}

current_hw_device [get_hw_devices xc7k325t_0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7k325t_0] 0]
set_property PROBES.FILE {} [get_hw_devices xc7k325t_0]
set_property FULL_PROBES.FILE {} [get_hw_devices xc7k325t_0]
set_property PROGRAM.FILE $bitstream_file [get_hw_devices xc7k325t_0]
program_hw_devices [get_hw_devices xc7k325t_0]
refresh_hw_device [lindex [get_hw_devices xc7k325t_0] 0]

close_hw_manager
