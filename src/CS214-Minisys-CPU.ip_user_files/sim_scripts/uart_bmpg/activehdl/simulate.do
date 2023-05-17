onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+uart_bmpg -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.uart_bmpg xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {uart_bmpg.udo}

run -all

endsim

quit -force
