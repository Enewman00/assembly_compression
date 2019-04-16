#EEN170000
#Ethan Newman

#EXAMPLE RUN
#Please enter a file name: MIPS\\homework8\\hello.txt

#Original Data:
#hello
#Compressed Data:
#h1e1l2o1
#Uncompressed Data:
#hello
#Original file size:
#5
#Compressed file size:
#8
#Please enter a file name: MIPS\\homework8\\hello-art.txt

#Original Data:
#  ___ ___         .__  .__            __      __            .__       .___._.
# /   |   \   ____ |  | |  |   ____   /  \    /  \___________|  |    __| _/| |
#/    ~    \_/ __ \|  | |  |  /  _ \  \   \/\/   /  _ \_  __ \  |   / __ | | |
#\    Y    /\  ___/|  |_|  |_(  <_> )  \        (  <_> )  | \/  |__/ /_/ |  \|
# \___|_  /  \___  >____/____/\____/    \__/\  / \____/|__|  |____/\____ |  __
#       \/       \/                          \/                         \/  \/
#Compressed Data:
# 2_3 1_3 9.1_2 2.1_2 <_2 6_2 <.1_2 7.1_3.1_1.1
#1 1/1 3|1 3\1 3_4 1|1 2|1 1|1 2|1 3_4 3/1 2\1 4/1 2\1_;|1 2|1 4_2|1 1_1/1|1 1|1
#1/1 4~1 4\1_1/1 1_2 1\1|1 2|1 1|1 2|1 2/1 2_1 1\1 2\1 3\1/1\1/1 3/1 2_1 1\1_1 2_2 1\1 2|1 3/1 1_2 1|1 1|1 1|1
#1\1 4Y1 4/1\1 2_3/1|1 2|1_1|1 2|1_1(1 2<1_1>1 1)1 2\1 8(1 2<1_1>1 1)1 2|1 1\1/1 2|1_2/1 1/1_1/1 1|1 2\1|1
#1 1\1_3|1_1 2/1 2\1_3 2>1_4/1_4/1\1_4/1 4\1_2/1\1 2/1 1\1_4/1|1_2|1 2|1_4/1\1_4 1|1 2_2
#1 7\1/1 7\1/1 J\1/1 I\1/1 2\1/1
#Uncompressed Data:
#  ___ ___         .__  .__            __      __            .__       .___._.
# /   |   \   ____ |  | |  |   ____   /  \    /  \___________|  |    __| _/| |
#/    ~    \_/ __ \|  | |  |  /  _ \  \   \/\/   /  _ \_  __ \  |   / __ | | |
#\    Y    /\  ___/|  |_|  |_(  <_> )  \        (  <_> )  | \/  |__/ /_/ |  \|
# \___|_  /  \___  >____/____/\____/    \__/\  / \____/|__|  |____/\____ |  __
#       \/       \/                          \/                         \/  \/
#riginal file size:
#467
#Compressed file size:
#462
#Please enter a file name: 

#-- program is finished running --


.data
empty: 		.asciiz ""
inputBuffer:	.space 100
fileBuffer:	.space 1024
uncompBuffer:	.space 1024

.include "macros.asm"		#use the macros from macros.asm file


#$t0 is heap memory address
#$t1 is userinput
#$t2 is file contents address
#$t3 is char in string of file
#$s1 is original file size
#$s2 is compressed file size

.text
main:
	#allocate 100 bytes to heap, address of allocated stored in $t0
	allocateMemory(1024)
	move $t0, $v0	#address of allocated memory in $t0
	
loop:
	printString("Please enter a file name: ")
	readString	#return string stored in $v0
	la $t1, inputBuffer

	la $t6, empty
	
	#load char from each into $t6 and 7 to compare them.
	lb $t6, ($t6)
	lb $t7, ($t1)
	
	#if they are equal (input is empty), exit
	beq $t7, $t6, exit
	

#a. Open the file for reading. If the file does not exist, 
#print an error message and terminate the program.
	
	
	la $a0, inputBuffer
	openFile

	#if file descriptor is negative, error and exit
	printString("\n")
	blt $s0, 0, printError
	

#b. Read the file into an input buffer space of 1024 bytes.
	readFile
	move $s1, $v0
	

#c. Close the file
	closeFile

#d. Output the original data to the console
	printString("Original Data:\n")
	la $a0, fileBuffer
	printStringa0
	printString("\n")
	
#e. Call the compression function. 
#   Save the size of the compressed data in memory.
#$t0 contains address of the allocated memory

#3.The compression function implements the RLE algorithm 
#above and stores the compressed data in the heap. Before the 
#function call, set $a0 to the address of the input buffer, set 
#$a1 to the address of the compression buffer, set $a2 to the size 
#of the original file. The function should “return” the size of the
# compressed data in $v0. 
la $a0, fileBuffer
move $a1, $t0
move $a2, $s1

la $t1, fileBuffer		#load file buffer pointerinto $t1
move $t2, $t0				#$t2 = mem address
lb $t3, ($t1)			#$t3 = previous char
addi $t1, $t1, 1		#move file pointer over by one
lb $t4, ($t1)			#$t4 = current char
li $t5, 1			#$t5 = 1 (count)
li $t6, 0			#$t6 = 0 (compressed size)

fileLoop:
	beq $t3, $t4, equal	#if two in a row, add 1 to count
	#else
	sb $t3, ($t2)		#put in the letter to the compressed
	addi $t2, $t2, 1	#increase memory address by 1
	addi $t5, $t5, 48	#change to ascii value of number
	sb $t5, ($t2)		#put number in compressed
	li $t5, 1		#reset count
	addi $t2, $t2, 1	#increase memory address by 1
	addi $t6, $t6, 2	#increase size count by 2
	
	j next			#skip to next
	
	equal:
	addi $t5, $t5, 1	#increase count by 1
	
	next:
	lb $t3, ($t1)		#change prev to current
	addi $t1, $t1, 1	#change pointer by 1
	lb $t4, ($t1)		#change current to pointer item
	
	bne $t3, $0, fileLoop	#END OF LOOP
move $s2, $t6
move $v0, $t6

#f.Call a function to print the compressed data.
printString("Compressed Data:\n")
move $a0, $t0
printStringa0
printString("\n")

#g.Call the uncompress function. Print the uncompressed data.
la $t7, uncompBuffer
printString("Uncompressed Data:\n")
li $t6, 0			#count of uncompressed data
move $t2, $t0			#copy address of heap into t2
unLoop:
	lb $t3, ($t2)		#letter (h) in t3
	addi $t2, $t2, 1	#move pointer over
	lb $t4, ($t2)		#count + 48 (49) in t4
	subi $t4, $t4, 48	#t4 -= 48
	addi $t2, $t2, 1	#move pointer over
	
	li $t5, 0		#nested loop count = 1
	unNested:
		printCharReg($t3)	#print the character n times
		sb $t3, ($t7)		#store byte into uncompBuffer
		addi $t7, $t7, 1	#move uncompBuffer pointer 1
		addi $t5, $t5, 1	#add 1 to loop count
		bne $t5, $t4, unNested
	
	addi $t6, $t6, 2	#unLoop counter
	
	bne $t6, $s2, unLoop

	#print uncompressed buffer -- commented out because doing it during
	#storage. More efficient that way.
	#la $a0, uncompBuffer
	#printStringa0


#h.Print the number of bytes in the original and compressed data.
printString("\nOriginal file size:\n")
printIntReg($s1)
printString("\n")

	
printString("Compressed file size:\n")
printIntReg($s2)
printString("\n")




#exit
	j loop

printError:
	printString("ERROR: file does not exist")

exit:
	li $v0, 10
	syscall

