.global _start
.intel_syntax noprefix


.data
	print_message : .ascii "Enter number to check pallindrome: "
	message_len = (. - print_message)
	true : .ascii "True"
	false : .ascii "False" 
	newline : .ascii "\n"

.bss
	inbuf : .skip 32

.text
_start:
	#Print In msg
	mov rax, 1
	mov rdi, 1
	lea rsi, [print_message]
	mov rdx, message_len
	syscall

	#Taking input in string
	mov rax, 0
	mov rdi, 0
	lea rsi, [inbuf]
	mov rdx, 32
	syscall	
	
	#Convert to quad
	lea rdi, [inbuf]
	xor rax, rax
	xor rcx, rcx
	call .convert
	
	#Calling pallindrome function
	mov r8, rax
	xor r9, r9
	call .check_pallindrome
	cmp r8, r9
	
	#Comparing final values for output
	cmp r8, r9
	je .print_true
	mov rax, r9
	cqo
	mov rsi, 10
	idiv rsi
	cmp r8, rax
	je .print_true
	jmp .print_false

.convert:
	mov cl, byte ptr [rdi]
	test cl, cl
	jz .return
	cmp cl, '0'
	jl .return
	cmp cl, '9'
	jg .return
	sub cl, '0'
	imul rax, rax, 10
	add rax, rcx
	inc rdi
	jmp .convert

.check_pallindrome:
	cmp r8, r9
	jl .return
	mov rax, r8
	cqo
	mov rsi, 10
	idiv rsi
	imul r9, r9, 10
	add r9, rdx
	mov r8, rax
	jmp .check_pallindrome
	
.print_true:
	mov rax, 1
	mov rdi, 1
	lea rsi, [true]
	mov rdx, 4
	syscall
	jmp .exit
	
.print_false:
	mov rax, 1
	mov rdi, 1
	lea rsi, [false]
	mov rdx, 5
	syscall
	jmp .exit

.return:
	ret

.exit:
	mov rax, 60
 	mov rdi, 0
	syscall