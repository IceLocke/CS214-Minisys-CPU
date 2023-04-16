# CS214 2023s Project Quick Start

## 0 Deadlines & References

| 答辩时间           | 代码   | 文档   | 得分系数 |
| -------------- | ---- | ---- | ---- |
| 5.22 (-42days) | 5.22 | 5.29 | 1.05 |
| 5.29 (-49days) | 5.29 | 6.5  | 1    |

[Project 要求](https://bb.sustech.edu.cn/bbcswebdav/pid-379028-dt-content-rid-13103060_1/courses/CS214-30000386-2023SP/Computer%20Orgnization%E5%A4%A7%E4%BD%9C%E4%B8%9A-cs214-%E5%88%9D%E7%A8%BF.pdf)

[MINISYS 硬件手册](https://bb.sustech.edu.cn/bbcswebdav/pid-379291-dt-content-rid-13134743_1/courses/CS214-30000386-2023SP/Minisys%E7%A1%AC%E4%BB%B6%E6%89%8B%E5%86%8C1.1.pdf) 

[Fros1er/Simple_Minisys_CPU](https://github.com/Fros1er/Simple_Minisys_CPU)

[MIPS Reference Data](https://inst.eecs.berkeley.edu/~cs61c/resources/MIPS_Green_Sheet.pdf)

## 1 Todos

### 1.1 Basic

#### 1.1.1 ISA

这一部分主要就是实现 Minisys 的基本指令，以及 MIPS 中的一些扩展。在硬件上，我们参考 Minisys 的 datapath 进行模块化设计。

![](./img/datapath.png)

##### 需要实现的（子）模块

1. CPU clock generator
   
   CPU 的时钟信号发生器，可以使用 vivado 提供的 clk_wiz IP 核实现。

2. Instruction fetcher
   
   根据 PC 寄存器从 instruction memory 中取得指令。Inst. memory 可以直接使用 vivado 提供的 block memory 实现。
   
   如果考虑实现 bonus 部分的中断支持，可以实现一个 VIC (Vector interrupt control)，VIC 中定义了一系列具有优先级的中断信息，可以令 CPU 停下当前工作，通过 handler 进行中断处理。如果我们实现了 VIC，在与外设的交互中，就可以使用中断（而不是轮询）实现 I/O 以实现更高的性能。
   
   ![](./img/IO_2ways.png)
   
   与 PC 相关的指令可以考虑在这里对 PC 进行更改。

3. Registers
   
   寄存器组。包括 32 个通用寄存器。)
   
   ![](./img/registers.png)

4. ALU
   
   算数的。实现有符号/无符号的加法/减法，逻辑运算，大小对比即可。

5. Control unit
   
   对 Inst. fetcher 提供的指令进行解析，比较麻烦的一部分。

6. Data Memory
   
   数据内存，可以直接使用 block memory 实现。具有 32 位的寻址空间，寻址单位 1byte，一次写入 4bytes，数据空间不知道，就 128M 吧（？）。这里注意，因为（我打算）使用 MMIO（内存映射IO，也就是说将一段内存地址与外设的输入输出值进行映射，这样方便实现 bonus 中的功能），使用在 data memory 的开始字段需要保留一些空间用于 IO 的内存映射。

##### 需要实现的指令

| Type | Name | Type | Name  | Type | Name  | Type | Name |
| ---- | ---- | ---- | ----- | ---- | ----- | ---- | ---- |
| R    | sll  | R    | srav  | R    | subu  | R    | slt  |
| R    | srl  | R    | jr    | R    | and   | R    | sltu |
| R    | sllv | R    | add   | R    | or    | -    | -    |
| R    | srlv | R    | addu  | R    | xor   | -    | -    |
| R    | sra  | R    | sub   | R    | nor   | -    | -    |
| I    | beq  | I    | sw    | I    | slti  | I    | ori  |
| I    | bne  | I    | addi  | I    | sltiu | I    | xori |
| I    | lw   | I    | addiu | I    | andi  | I    | lui  |
| J    | j    | J    | jal   | -    | -     | -    | -    |

#### 1.1.2 I/O

这里我想使用 MMIO 进行开发，所以说约定好需要使用到的管脚对应的内存空间就行了。然后使用时钟分频对内存空间进行不那么快的访问，直接用更新内存数据就行。

需要实现一个 I/O 模块。

#### 1.1.3 Uart

可以直接使用 vivado 提供的 uart IP 核解决。通过 uart 串口将指令写入 instruction memory。

需要实现一个 uart 模块。

### 1.2 Bonus

Bonus 部分看了一下，比较好玩而且容易实现的：

- 实现对复杂外设接口的支持（如VGA接口、小键盘接口等）
  
  可以使用 MMIO 以及 VIC 中断轻松实现。我们可以实现一个小键盘的接口~~因为已经有现成的代码可以参考~~

- 实现对中断的支持
  
  也就是实现一个 VIC 协处理器。具体可以参考 [Vector Interrupt Controller](https://upload.wikimedia.org/wikiversity/en/f/fa/ARM.2ASM.VIC.20220725.pdf)，我还没细看。

#### 1.1.4 模块列表

| 名称                  | 功能  | 负责人 |
| ------------------- | --- | --- |
| cpu_top             |     |     |
| cpu_clk             |     |     |
| instruction_fetch   |     |     |
| instruction_memory  |     |     |
| registers           |     |     |
| control             |     |     |
| alu                 |     |     |
| data_memory         |     |     |
| io (包括 开关，LED，数码管等) |     |     |
| uart                |     |     |

## 2 约定

**对于代码，我们采用如下风格：小写单词+下划线命名，常量全大写，运算符中间打空格！！！**

### 2.1 ISA Machine code

![instruction.png](./img/instruction.png)

#### 2.1.1 R Type

| Name                            | Mnemonic | funct (ins[5:0]) | Note        |
| ------------------------------- | -------- | ---------------- | ----------- |
| Shift left logical              | sll      | 000000           | 移动 shamt 的值 |
| Shift right logical             | srl      | 000010           | 同上          |
| Shift left logical variable     | sllv     | 000100           |             |
| Shift right logical variable    | srlv     | 000110           |             |
| Shift right arithmetic          | sra      | 000011           | 同上，忽略溢出     |
| Shift right arithmetic variable | srav     | 000111           | 同上          |
| Jump register                   | jr       | 001000           | PC=rs       |
| Add                             | add      | 100000           |             |
| Add unsigned                    | addu     | 100001           |             |
| Substract                       | sub      | 100010           |             |
| Substract unsigned              | subu     | 100011           |             |
| And logical                     | and      | 100100           |             |
| Or logical                      | or       | 100101           |             |
| Xor logical                     | xor      | 100110           |             |
| Nor logical                     | nor      | 100111           |             |
| Set less than                   | slt      | 101010           |             |
| Set less than unsigned          | sltu     | 101011           |             |

#### 2.1.2 I Type

#### 2.1.3 J Type

### 2.2 I/O 内存映射
