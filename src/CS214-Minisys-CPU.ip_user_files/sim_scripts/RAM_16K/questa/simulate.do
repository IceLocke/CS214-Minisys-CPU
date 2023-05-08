onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib RAM_16K_opt

do {wave.do}

view wave
view structure
view signals

do {RAM_16K.udo}

run -all

quit -force
