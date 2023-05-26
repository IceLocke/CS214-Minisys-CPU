onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib cpu_wiz_clk_opt

do {wave.do}

view wave
view structure
view signals

do {cpu_wiz_clk.udo}

run -all

quit -force
