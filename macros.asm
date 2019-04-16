#EEN170000
#Ethan Newman

#-------------------------print integer--------------------
.macro printInt (%intValue)

li $v0, 1
li $a0, %intValue	#load parameter into $a0 to be called
syscall

.end_macro


#-------------------------print integer in register--------------------
.macro printIntReg (%intReg)

li $v0, 1
move $a0, %intReg	#load parameter into $a0 to be called
syscall

.end_macro


#-------------------------print character--------------------
#printChar('a')
.macro printChar (%charValue)

li $v0, 11
li $a0, %charValue

.end_macro


#-------------------------print character in $t3--------------------
#printChar('a')
.macro printCharReg (%register)

li $v0, 11
move $a0, %register
syscall
.end_macro


#-------------------------print string in register $a0--------------------
.macro printStringa0

li $v0, 4
syscall

.end_macro



#-------------------------print string--------------------
#printString("testString")
.macro printString (%stringValue)
.data
toPrint: 	.asciiz %stringValue
.text
li $v0, 4
la $a0, toPrint
syscall

.end_macro

#-------------------------get String from user--------------------
#getString
.macro readString
.text
li $v0, 8
la $a0, inputBuffer	#where input is stored
li $a1, 100		#max chars
syscall

#replace \n in string with null
add $t6, $0, $0
addi $t7, $0, 10
#addi $t3, $0, 'r'
la $t1, inputBuffer
#la $t4, inputBuffer
#sb $t3, ($t1)
loop:
	lb $t5, ($t1)
	beq $t5, $t7, finish
	addi $t1, $t1, 1
	j loop
finish:
	sb $0, ($t1)


.end_macro


#-------------------------open file--------------------
#opens file in $t1
#openFile ("MIPS/homework8/hello.txt")
.macro openFile #(%fileName)
#.data
#file:	.asciiz %fileName 	#puts file name in file
.text
li $v0, 13			#open file
#move $a0, %fileName	#was la

li $a1, 0
li $a2, 0
syscall
#move file descriptor to $s0
move $s0, $v0
.end_macro



#-------------------------close file--------------------
.macro closeFile
#closeFile		closes currently open file
li $v0, 16
move $a0, $s0		#file descriptor stored in $s0, now copied into $a0
syscall

.end_macro



#-------------------------read file--------------------
.macro readFile
#.data
#buffer: .space 80
.text
li $v0, 14
move $a0, $s0		#file descriptor in $s0
la $a1, fileBuffer
li $a2, 500		#max number of character to read
syscall
#la $s1, buffer		#address of buffer in $s1
.end_macro



#-------------------------allocate heap memory--------------------
.macro allocateMemory(%numBytes)

li $v0, 9
li $a0, %numBytes	#load parameter into $a0 to be called
syscall			#$v0 now contains address of allocated memory
#return address of allocated memory in $v0

.end_macro




