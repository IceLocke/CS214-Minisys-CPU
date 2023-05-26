onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+cpu_wiz_clk -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.cpu_wiz_clk xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {cpu_wiz_clk.udo}

run -all

endsim

quit -force
