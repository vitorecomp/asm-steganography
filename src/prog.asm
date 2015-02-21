%include "io.mac"
section .bss
	Buff resb 1
	structHeader resb 20
	;file Descriptor					4 bytes
	;lines								4 bytes
	;cols								4 bytes
	;linejump -> lines * 3 + padding	4 bytes
	;imageHeaderSize					4 bytes


	imageData resb 3145728
	palavra resb 1


section .data
	imageGetNameS db 'Type the image name:', 0
	sapace db ' , ', 0
	imageName  times 100 db ' ', 0

	link times 314572 db ' ', 0
	bitos db 0, 0




	errorMsg db 'Erro ao abrir a imgem, numero:', 0

section .text
	global _start

_start:
	nop            ;This no-op keeps the debugger happy

	call getImageName 	;le o nome da imagem do usuario
	call openImage		;carrega o arquivo da imagem na memoria
	call readHeader		;le tudo que é util do cabecalho e armeza nas posicoes ->
	call makeLink		;pega as infos da "readHeader", e remove o link armazendo na memoria
	

exit:
	;finalizando o programa
	mov eax,1	; Codigo: Exit Syscall
	mov ebx,0	; Return 0
	int 80H		; interrupçao d de sistema

getImageName:
	PutStr imageGetNameS
	GetStr imageName, 100
	ret

openImage:
	mov EAX, 5
	mov EBX, imageName
	mov ECX, 0
	mov EDX, 0700
	int 80H


	Push	EAX
	mov [structHeader], EAX

	cmp EAX , 0
	jge allOk
	
	PutStr errorMsg
	PutLInt EAX
	nwln
	jmp exit

allOk:
	pop EAX
	mov EBX, EAX
	mov EAX, 3
	mov ECX, imageData
	mov EDX, 3145728
	int 80H
	ret

readHeader:
	mov EAX, [imageData + 10]
	mov [structHeader + 16], EAX

	mov EAX, [imageData + 18]
	mov BX, AX

	mov EAX, [imageData + 22]
	mov [structHeader + 4], EAX

	mov AX, 3
	MUL BX
	mov [structHeader + 8], EAX

	mov CX, AX
	sar CX, 2
	shl CX, 2
	sub AX, CX

	cmp AL, 0
	jz noPadding
	mov AH, 4 
	sub AH, AL
	mov AL, AH
noPadding:
	mov CL, AL
	mov CH, 0
	mov AX, 3
	MUL BX
	ADD AX, CX

	mov [structHeader + 12], EAX
	ret

makeLink:
	mov EBX, [structHeader + 16] ;pega inicio do cabecalho
	mov ECX, [structHeader + 4]  ;pega quantas linhas
	mov EAX, 0 ;
loopLines:
	mov EDX, 0
loopCols:
	
	mov AL, [imageData + EBX + EDX] ;pega um pixel
	call addBit
	
	;loop de linhas
	inc EDX
	cmp EDX, [structHeader + 8]

	jnz loopCols

	;legal pro ofset de linhas
	add EBX, [structHeader + 12]
	;conta as linhas
	loop loopLines
	nwln
ret

;faz a opp de pegar bits
;qunado 8 inverte e imprime
addBit:
	pusha
	mov AH, [palavra]
	sal AH, 1
	sal AL, 8
	adc AH, 0
	mov [palavra], AH
	mov AL, [bitos]
	inc AL
	mov [bitos], AL
	cmp AL, 8
	jne fim
	;PutCh AH
	cmp AH, 0
	je exit
	call reverse
	mov AL, AH
	mov AH, 0
	PutCh AL
	mov AL, 0
	mov [bitos], AL

fim:
	popa

reverse:	
	push CX
	push AX

	mov CH, 0
	mov AL, AH
	and AL, 10000000b
	sar AL, 7
	and AL, 00000001b
	or CH, AL 

	mov AL, AH
	and AL, 01000000b
	sar AL, 5
	or CH, AL

	mov AL, AH
	and AL, 00100000b
	sar AL, 3
	or CH, AL

	mov AL, AH
	and AL, 00010000b
	sar AL, 1
	or CH, AL

	mov AL, AH
	and AL, 00001000b
	sal AL, 1
	or CH, AL

	mov AL, AH
	and AL, 00000100b
	sal AL, 3
	or CH, AL

	mov AL, AH
	and AL, 00000010b
	sal AL, 5
	or CH, AL

	mov AL, AH
	and AL, 00000001b
	sal AL, 7
	or CH, AL

	pop AX
	mov AH, CH
	pop CX
	ret
	



