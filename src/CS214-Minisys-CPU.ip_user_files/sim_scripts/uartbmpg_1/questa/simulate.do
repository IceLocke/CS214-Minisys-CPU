onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib uartbmpg_opt

do {wave.do}

view wave
view structure
view signals

do {uartbmpg.udo}

run -all

quit -force
