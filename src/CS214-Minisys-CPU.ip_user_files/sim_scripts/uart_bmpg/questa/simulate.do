onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib uart_bmpg_opt

do {wave.do}

view wave
view structure
view signals

do {uart_bmpg.udo}

run -all

quit -force
