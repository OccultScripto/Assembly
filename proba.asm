.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
sir Db 'Abc   '
lung equ $-sir
msg db "%d ",10,13,0
tmp dd 0
;aici declaram date
.code
start:
	;aici se scrie codul
	mov esi,0
	mov ecx, lung
	et:
	mov eax,0
	mov al,sir[esi]
	;mov tmp, eax
	;mov ah, sir
	;inc esi
	pusha
	push eax
	push offset msg
	call printf
	add esp, 8
	popa
	inc esi
	
	loop et
	
	;terminarea programului
	push 0
	call exit
end start
