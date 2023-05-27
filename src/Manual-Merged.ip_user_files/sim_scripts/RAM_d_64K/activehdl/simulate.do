onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+RAM_d_64K -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_1 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.RAM_d_64K xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {RAM_d_64K.udo}

run -all

endsim

quit -force