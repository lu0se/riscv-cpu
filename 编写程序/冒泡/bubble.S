init:
#x31=0xE0000000,七段数码管端口
#内存0x0~0x28:10个被操作的冒泡排序内存区
lui x31,0xE0000

#冒泡排序
#每趟排序后输出一次 冒泡排序内存区
#for(int i = 0; i < 9; i++){
#        for(int j = 0; j < 9 - i; j++){
#            iff(arr[j] < arr[j+1]){
#                int temp = arr[j];
#                arr[j] = arr[j+1];
#                arr[j+1] = temp;
#            }
#        }
#        displaymem();
#    }
#循环显示finish

#外层循环
addi x19,x0,0x0 #x19=0(i=0)
addi x22,x0,0x9
for1tst:bge x19,x22,exit1
#内层循环
addi x21,x0,0x9
sub x21,x21,x19 #x21=9-i
addi x20,x0,0x0 #x20=0(j=0)
for2tst:bge x20,x21,exit2
slli x5,x20,0x2 #x5=j*4
lw x7,0x0(x5) #x7=arr[j]
lw x8,0x4(x5) #x8=arr[j+1]
bge x7,x8,notif #arr[j]>=arr[j+1],跳转到不成立

sw x8,0x0(x5)
sw x7,0x4(x5)

notif: addi x20,x20,0x1
jal x0,for2tst

#外层循环
exit2:jal x1,displaymem 
#冒一次泡，显示一次内存
addi x19,x19,0x1
jal x0,for1tst

#外层循环结束
exit1:addi x18,x0,0x000000f1
loopdisf1:sw x18,0x0(x31)
jal x0,loopdisf1

#显示内存函数
displaymem:addi x17,x0,0x0 #初始化内存显示位置
lui x13,0xFFE00 #初始化计时器值


loop: addi x13,x13,0x1 #r13= r13 + 1 ( r13 的初始值为 0xFFF70000 )，依靠程序中的计数器，当 r13 到了 0，换一组显示，重新开始计数
beq x13,x0,next

Disp: lw x18,0x0(x17)
sw x18,0x0(x31) #7 段文本显示 S9，
jal x0,loop

next: lui x13,0xFFE00 #r13=0xFFF70000
addi x17, x17, 0x4 #访存地址加 4
addi x6,x0,0x29 #x6为内存区范围外
bge x17, x6, L2 #如果 r17 的值到了 0x2c ，就重新设置 r17 从 4 开始,并退出显示内存函数
jal x0, Disp
L2: jalr x0, x1,0x0 #退出显示内存函数
