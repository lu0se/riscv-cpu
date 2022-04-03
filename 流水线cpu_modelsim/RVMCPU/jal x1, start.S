jal x1, start
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
start: lui x4, 0xFFFFF #x4=0xFFFFFFFF
srai x4,x4,12 #x4=0xFFFFFFFF
add x5,x4,x4 #x5=0xFFFFFFFE
add x5,x5,x5 #x5=0xFFFFFFFC
add x5,x5,x5 #x5=0xFFFFFFF8
add x5,x5,x5 #x5=0xFFFFFFF0
add x5,x5,x5 #x5=0xFFFFFFE0
add x5,x5,x5 #x5=0xFFFFFFC0
ori x20,x0,0x3f#r20=0x0000003F
add x5,x5,x5 #x5=0xFFFFFF80
add x5,x5,x5 #x5=0xFFFFFF00
add x5,x5,x5 #x5=0xFFFFFE00
add x5,x5,x5 #x5=0xFFFFFC00
add x5,x5,x5 #x5=0xFFFFF800
add x5,x5,x5 #x5=0xFFFFF000
add x5,x5,x5 #x5=0xFFFFE000
add x5,x5,x5 #x5=0xFFFFC000
add x5,x5,x5 #x5=0xFFFF8000
add x5,x5,x5 #x5=0xFFFF0000
add x5,x5,x5 #x5=0xFFFE0000
add x5,x5,x5 #x5=0xFFFC0000
add x5,x5,x5 #x5=0xFFF80000
add x5,x5,x5 #x5=0xFFF00000
add x5,x5,x5 #x5=0xFFE00000
add x5,x5,x5 #x5=0xFFC00000
add x5,x5,x5 #x5=0xFF800000
add x5,x5,x5 #x5=0xFF000000
add x5,x5,x5 #x5=0xFE000000
add x5,x5,x5 #x5=0xFC000000
add x6,x5,x5 #x6=0xF8000000
add x5,x6,x6 #x5=0xF0000000
add x7,x5,x5 #x7=0xE0000000
add x13,x7,x7#x13=0xC0000000
add x8,x13,x13 #r8=0x80000000
sltu x9,x0,x4 #x9=0x00000001 unsigned slt
add x14,x9,x9#x14=0x2add x14,x14,x14 #r14=0x4
add x10,x4,x4#x10=0xFFFFFFFE
sw x6,4(x5) #counter port:f0000004,r6=0xF8000000,设置计数器初值
lw x25,0(x5) #{counter0_out,counter1_out,counter2_out,led_out[12:0], SW};
add x25,x25,x25
add x25,x25,x25
sw x25,0(x5) #{GPIOf0[13:0],LED,counter_set}, port:f0000000
add x19,x19,x9 #r19 uninitilized, r19 = 1
sw x19,0(x7) #r9 送 x7=0xE0000000 七段数码管端口
lw x13,0x14($0) #r13=0xFFF70000, 20 号内存单元对应 5 号字
loop: lw x25,0(x5) #{counter0_out,counter1_out,counter2_out,led_out[12:0], SW}
add x25,x25,x25
add x25,x25,x25
sw x25,0(x5) #{GPIOf0[13:0],LED,counter_set}, port:f0000000
lw x25,0(x5) #{counter0_out,counter1_out,counter2_out,led_out[12:0], SW}
and x11,x25,x8 #取 r5 最高位，counter0_out 虽然取出，并没有使用
add x13,x13,x9 #r13= r13 + 1 ( r13 的初始值为 0xFFF70000 )，依靠程序中的计数器，当 r13 到了 0，换一组显示，重新开始计数
beq x13,x0,next
Disp: lw x25,0(x5) #{counter0_out,counter1_out,counter2_out,led_out[12:0], SW}, port:f0000000
add x18,x14,x14 #r18 = 8
add x22,x18,x18 #r22=0x10
add x18,x18,x22 #r18=0x18
and x11,x25,x18 #取出 SW[4:3]的值，其他位为 0
beq x11,x0,L00 #SW[4:3]=0x00，跑马灯
beq x11,x18,L11 #SW[4:3]=0x11，显示七段图形
add x18,x14,x14 #r18=0x8
beq x11,x18,L01 #SW[4:3]=0x01，显示预置数字
sw x19,0(x7) #SW[4:3]=0x10，显示 r9，L10
jal x1,loop
L00: beq x10,x4,L4 #r4 =0xFFFFFFFF，跑马灯，如果 r10 的值已经到了 0xFFFFFFFF ，转入L4 设置 r10 为 0xFFFFFFFE
jal x1,L3
L4: or x10,x4,x0#r10=0xFFFFFFFF
add x10,x10,x10 #r10=0xFFFFFFFE
L3: sw x10,0(x7) #7 段图形显示 r10
jal x1,loop
L11: lw x19,0x60(x17)
sw x19,0(x7) #7 段图形显示 x19，矩阵变化
jal x1,loop
L01: lw x19,0x20(x17)
sw x19,0(x7) #7 段文本显示 S9，00000000, 11111111, 22222222, 33333333, ……jal x1,loop
next: lw x13,0x14(x0) #r13=0xFFF70000
add x10, x10, x10 
or x10, x10, x9 #r10 是用于跑马灯的显示，每次显示后左移 1 位，再加 1
add x17, x17, x14 #访存地址加 4
and x17, x17, x20 #r20=0x0000003F（取$17 的低 6 位，$17 是地址的偏移，在 0、4、8、12，……，60 (0x3C) 之间循环）
add x19, x19, x9 #r19=r19+1，当 SW[4:3]=0x10，显示 r19 的值在递增
beq x19, x4, L2 #r4 = 0xFFFFFFFF ，如果 r19 的值到了 0xFFFFFFFF ，就重新设置 r19 从 5 开始
jal x1, L5
L2: add x19, x0, x14 #r19=0x4
add x19, x19, x9 #r19=0x5, 如果 r19 达到了 0xFFFFFFFF，就重新设置 r19 从 5开始
L5: lw x25, 0(x5)#{counter0_out,counter1_out,counter2_out,led_out[12:0], SW}, port:f0000000
add x11, x25, x25
add x11, x11, x11
sw x11, 0(x5) #{GPIOf0[13:0],LED,counter_set}, port:f0000000
sw x6, 4(x5) #counter port:f0000004,r6=0xF8000000，设置计数器的初值
lw x25, 0(x5) #{counter0_out,counter1_out,counter2_out,led_out[12:0], SW}, port:f0000000
and x11, x25, x8 #取 r5 最高位，r8 为 0x80000000，counter0_out 虽然取出，并没有使用
jal x1, Dis