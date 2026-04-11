# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Implementation-only flow that reuses an existing synthesized design.
set xilinx_root [file dirname [file dirname [file normalize [info script]]]]
source ${xilinx_root}/scripts/common.tcl

if { $argc < 2 } {
    puts "Error: Insufficient implementation arguments (${argc}): ${argv}."
    puts "Usage: impl_sys2.tcl <board> <project> [ip ...]"
    return -code error
}

set board [lindex $argv 0]
set proj [lindex $argv 1]
set num_threads 20
set num_jobs 20
set project_root ${xilinx_root}/build/${board}.${proj}
set project_file ${project_root}/${proj}.xpr

set_param general.maxThreads $num_threads

if { ![file exists $project_file] } {
    puts "Error: Existing project not found: ${project_file}"
    puts "Run impl_sys.tcl first (full synth+impl flow), then rerun impl_sys2.tcl."
    return -code error
}

open_project $project_file

if { [llength [get_runs synth_1 -quiet]] == 0 } {
    puts "Error: synth_1 run does not exist in ${project_file}."
    close_project
    return -code error
}

# Ensure implementation is based on the latest available synthesis run.
set synth_status [get_property STATUS [get_runs synth_1]]
if { ![string match -nocase {*complete*} $synth_status] } {
    puts "Error: synth_1 is not complete (status: ${synth_status})."
    puts "Complete synthesis first, e.g. by running impl_sys.tcl once."
    close_project
    return -code error
}

set_property strategy Flow_RunPostRoutePhysOpt [get_runs impl_1]

set impl_status [get_property STATUS [get_runs impl_1]]
puts "Info: impl_1 status before launch: ${impl_status}"

# Vivado can require explicit reset of write_bitstream even when impl_1 status
# does not contain "complete". Reset that step first, then fall back to full reset.
if { [catch {reset_run impl_1 -from_step write_bitstream} reset_msg] } {
    puts "Info: reset_run impl_1 -from_step write_bitstream failed: ${reset_msg}"
    puts "Info: Falling back to full impl_1 reset."
    if { [catch {reset_run impl_1} reset_msg2] } {
        puts "Error: Could not reset impl_1: ${reset_msg2}"
        close_project
        return -code error
    }
}

# Implementation
launch_runs -jobs $num_jobs impl_1 -to_step write_bitstream
wait_on_run impl_1
open_run impl_1

# Generate implementation reports
gen_reports ${project_root}/reports.impl

# Check timing constraints
set trep [report_timing_summary -no_header -no_detailed_paths -return_string]
if { ![string match -nocase {*timing constraints are met*} $trep] } {
    puts "Error: Timing constraints not met for ${proj} on ${board}."
    close_project
    return -code error
}

# Copy out final bitstream
file mkdir ${xilinx_root}/out
file copy -force ${project_root}/${proj}.runs/impl_1/cheshire_top_xilinx.bit \
    ${xilinx_root}/out/${proj}.${board}.bit
#file copy -force ${project_root}/${proj}.runs/impl_1/cheshire_top_xilinx.ltx \
#    ${xilinx_root}/out/${proj}.${board}.ltx

close_project
