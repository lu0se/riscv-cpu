#func quickSort(left, right int) {
#    iff left > right {
#        return
#    }
#    i, j, base := left, right, nums[left]
#    for i < j {
#        for nums[j] >= base && i < j {
#            j--
#        }
#        for nums[i] <= base && i < j {
#            i++
#       }
#        nums[i], nums[j] = nums[j], nums[i]
#    }
#    nums[i], nums[left] = nums[left], nums[i]
#    quickSort( left, i - 1)
#    quickSort( i + 1, right)
#}

#x31=0xE0000000,七段数码管端口
#内存0x0~0x28:10个被操作的快速排序内存区
#栈指针初值 0x200
init:
lui x31,0xE0000
addi x2,x0,0x300

main:
addi x10,x0,0
addi x11,x0,36
jal x1,quickSort
jal x0,exit

quickSort:
addi x2,x2,-24
sw x21,20(x2)#保存base
sw x20,16(x2)#保存j
sw x19,12(x2)#保存 i
sw x1,8(x2)  #保存返回地址 4(x2)
sw x10,4(x2) #保存left
sw x11,0(x2) #保存right

blt x10,x11,notif #arr[j]>=arr[j+1],跳转到不成立
jalr x0,x1,0x0 #函数返回

notif:
add x19,x0,x10 #x19 i
add x20,x0,x11 #x20 j
lw x21,0x0(x19) #x21 base

#外层循环
for1tst:bge x19,x20,exit1

for2tst:lw x22,0x0(x20) # x22 nums[j]
blt x22,x21,exit2
bge x19,x20,exit2
addi x20,x20,-4
jal x0,for2tst

exit2:
for3tst:lw x23,0x0(x19) # x23 nums[i]
blt x21,x23,exit3
bge x19,x20,exit3
addi x19,x19,4
jal x0,for3tst
exit3:
lw x22,0x0(x20) # x22 nums[j]
lw x23,0x0(x19) # x23 nums[i]
sw x22,0x0(x19)
sw x23,0x0(x20)
jal x0,for1tst
exit1:
lw x23,0x0(x19) # x23 nums[i]
sw x23,0x0(x10)
sw x21,0x0(x19)
#调用内存显示
add x0,x0,x0
add x0,x0,x0
jal x1,displaymem

add x8,x11,x0 # x8 right
addi x11,x19,-4 # x11 i-1
jal x1,quickSort
addi x10,x19,4 # x10 i+1
add x11,x8,x0 #x11 right
jal x1,quickSort

lw x21,20(x2)#恢复base
lw x20,16(x2)#恢复j
lw x19,12(x2)#恢复 i
lw x1,8(x2)  #恢复返回地址 4(x2)
lw x10,4(x2) #恢复left
lw x11,0(x2) #恢复right
addi x2,x2,24 #恢复栈空间
jalr x0,x1,0x0 #函数返回

#显示内存函数
displaymem:
addi x2,x2,-4
sw x1,0(x2)

addi x17,x0,0x0 #初始化内存显示位置
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
L2:
lw x1,0(x2)
addi x2,x2,4 
jalr x0, x1,0x0 #退出显示内存函数

exit:
addi x18,x0,0x000000f1
loopdisf1:sw x18,0x0(x31)
jal x0,loopdisf1