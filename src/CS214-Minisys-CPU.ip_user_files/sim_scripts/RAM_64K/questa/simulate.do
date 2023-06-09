onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib RAM_64K_opt

do {wave.do}

view wave
view structure
view signals

do {RAM_64K.udo}

run -all

quit -force
