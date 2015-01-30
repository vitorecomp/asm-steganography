section .bss
	Buff resb 1

section .data

section .text
	global _start

_start:
	nop            ;This no-op keeps the debugger happy

Read:
	ja getImageName ;le o nome da imagem do usuario
	ja openImage	;carrega o arquivo da imagem na memoria
	ja readHeader	;le tudo que é util do cabecalho e armeza nas posicoes ->
	ja makeLink		;pega as infos da "readHeader", e remove o link armazendo na memoria
	ja printLink	;printa o link
	

	;finalizando o programa
	mov eax,1	; Codigo: Exit Syscall
	mov ebx,0	; Return 0
	int 80H		; interrupçao d de sistema

getImageName:

openImage:

readHeader:

makeLink:

printLink:


Read:
	;start stack	
	
	;code
	mov eax,3      	; codigo sys_read call
	mov ebx,0      	; Specify File Descriptor 0: Standard Input
	mov ecx, Buff   ; offset do endereco de buffer onde vai armezenar
	mov edx, 1      ; Tell sys_read to read one char from stdin
	int 80h        	; Call sys_read

	;end stack
	
Write: 
	;start stack	
	
	;code
	mov eax,4		; codigo sys_write call
	mov ebx,1		; Specify File Descriptor 1: Standard output
	mov ecx,Buff	; offset do endereco de buffer onde vai armezenar
	mov edx,1		; vai ler so 1, verificando em cima se ñ e o \n
	int 80h			; Call sys_write...
	;end stack
	

