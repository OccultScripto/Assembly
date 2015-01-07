.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date

;declararea ferestrei
window_title DB "Proiect Stickman Ionut Indre",0
area_width EQU 640
area_height EQU 480
area DD 0

y DD 0 ; contor sus-jos
x DD 0 ; contor stanga-dreapta

yms DD 0	; memoreaza coordonatele contorului sus-jos
ymd DD 0
yps DD 0
ypd DD 0
ylc DD 0
ycjs DD 0
ycjd DD 0
ycsd DD 0
ycss DD 0

xms DD 0	;memoreaza coordonatele contorului stanga-dreapta
xmd DD 0
xps DD 0
xpd DD 0
xlc DD 0
xcjs DD 0
xcjd DD 0
xcsd DD 0
xcss DD 0

tmp DD 0	; utilizat pentru creare linie trunchiului
numarator DD 0	;numarator pentru apasarea tastei Q

arg1 EQU 8

.code

; functia de desenare - se apeleaza la apasarea fiecarei taste
; arg1 - key (tasta care s-a apasat, 0 pentru initializare)
draw proc

	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1]
	test eax, eax
	jnz key_notzero
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12	
	key_notzero:				;deseneaza background-ul negru
	mov edi, area
	mov ecx, area_height
	bucla_linii:
		push ecx
		mov ecx, area_width
	bucla_coloane:
		mov eax, 0000000h		; codul pentru culoarea neagra
		mov [edi], eax
		add edi, 4
		inc eax
	loop bucla_coloane
		pop ecx
	loop bucla_linii
	
afisare:
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'W'		; compara valoarea citita daca corespunde cu litera corespunzatoare
	je muta_sus			; sare la eticheta pentru a muta desenul mai sus
	cmp eax, 'A'		; analog si la restul
	je muta_st
	cmp eax, 'S'
	je muta_jos
	cmp eax, 'D'
	je muta_dr
	cmp eax, 'Q'		;sare la eticheta pentru a misca bratele
	je muta_maini

desenare_init:			; deseneaza stickman-ul la coordonatele initiale
	
	mov ecx, 0			; deseneaza marginiile de sus si de jos
	mov y, 0
	mov x, 0
MARGUP:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc x
	cmp ecx, 640
	jne MARGUP

	mov ecx, 0
	mov y, 479		   ;deviez un pixel mai jos deoarece nu se vede intreaga linie (480 implicit)
	mov x, 640
MARGDOWN:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h	; codul pentru culoarea rosie
	inc ecx
	dec x
	cmp ecx, 640
	jne MARGDOWN
	
	;cap
	mov ecx, 0	; linie jos-stanga
	mov y, 190
	mov x, 400
	mov ycjs, 190
	mov xcjs, 400
	NEXT1capjs:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capjs
	
	mov ecx, 0	;linie dreapta-jos
	mov y, 190
	mov x, 400
	mov ycjd, 190
	mov xcjd, 400
	NEXT1capjd:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capjd
	
	mov ecx, 0	; linie sus-dreapta
	mov y, 165
	mov x, 425
	mov ycsd, 165
	mov xcsd, 425
	NEXT1capsd:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capsd
	
	mov ecx, 0	; linie sus-stanga
	mov y, 165
	mov x, 375
	mov ycss, 165
	mov xcss, 375
	NEXT1capsst:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capsst

	;mana stanga
	mov ecx, 100
	mov y, 200
	mov x, 400
	mov yms, 200
	mov xms, 400
	NEXT1:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 150
	jne NEXT1
	
	;mana dreapta
	mov ecx, 100
	mov y, 200
	mov x, 400
	mov ymd, 200
	mov xmd, 400
	NEXT2:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT2
	
	;line corp
	mov ylc, 190
	mov xlc, 400
	mov ecx, 190
	NEXT3:
	mov eax, ecx	; muta sus-jos -y - +y
	mov ebx, area_width
	mul ebx
	add eax, xlc	;muta stanga-dreapta -x - +x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	cmp ecx, 300 	;110 pixeli pusi
	jne NEXT3
	
	;picior stanga
	mov ecx, 100
	mov y, 350
	mov x, 350
	mov yps,350
	mov xps, 350
	NEXT4:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT4
	
	;picior dreapta
	mov ecx, 100
	mov y, 300	
	mov x, 400	
	mov ypd, 300
	mov xpd, 400
	NEXT5:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT5
	
	popa			; afiseaza desenul si il pastreaza in aceeasi fereastra 
	mov esp, ebp
	pop ebp
	ret
	
stopSus:
	jmp desenare_init
	
muta_sus:	
	mov eax, ylc			; verifica daca nu depaseste ecranul in partea superioara
	sub eax, 55
	cmp eax, 2
	jl stopSus
		
	cmp numarator, 0		; verifica daca a fost apasata tasta Q		0- brate ridicate 1- brate lasate
	je wsus
	
	cmp numarator , 1
	je wjos
	
wjos:
	mov ecx, 0
	mov y, 0
	mov x, 0
	MARGUPwjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc x
	cmp ecx, 640
	jne MARGUPwjos
	
	mov ecx, 0
	mov y, 479  ;deviez un pixel mai jos
	mov x, 640
	MARGDOWNwjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec x
	cmp ecx, 640
	jne MARGDOWNwjos
	
	;cap
	mov ecx, 0	; linie jos-stanga
	mov eax, xcjs
	mov x, eax
	dec ycjs
	mov eax,ycjs
	mov y,eax
	NEXT1capjswjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capjswjos
	
	mov ecx, 0	;linie dreapta-jos
	mov eax, xcjd
	mov x, eax
	dec ycjd
	mov eax,ycjd
	mov y,eax
	NEXT1capjdwjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capjdwjos
	
	mov ecx, 0	; linie sus-dreapta
	mov eax, xcsd
	mov x, eax
	dec ycsd
	mov eax,ycsd
	mov y,eax
	NEXT1capsdwjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capsdwjos
	
	mov ecx, 0	; linie sus-stanga
	mov eax, xcss
	mov x, eax
	dec ycss
	mov eax,ycss
	mov y,eax
	NEXT1capsstwjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capsstwjos
	
	;mana stanga lasata jos
	mov ecx, 100
	mov eax, xms
	mov x, eax
	dec yms
	mov eax,yms
	mov y,eax
	NEXT1sus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	dec x
	cmp ecx, 150
	jne NEXT1sus
	
	;mana dreapta
	mov ecx, 100
	mov eax, xmd
	mov x, eax
	dec ymd
	mov eax,ymd
	mov y,eax
	NEXT2sus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT2sus

	;line corp
	mov tmp, 0
	mov eax, xlc
	mov x, eax
	dec ylc
	mov eax,ylc
	mov y,eax
	NEXT3sus:
	mov eax, y	; muta sus-jos -y - +y
	mov ebx, area_width
	mul ebx
	add eax, x	;muta stanga-dreapta -x - +x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc tmp
	inc y
	cmp tmp, 110
	jne NEXT3sus
	
	;picior stanga
	mov ecx, 100
	mov eax, xps
	mov x, eax
	dec yps
	mov eax,yps
	mov y,eax
	NEXT4sus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT4sus
	
	;picior dreapta
	mov ecx, 100
	mov eax, xpd
	mov x, eax
	dec ypd
	mov eax,ypd
	mov y,eax
	NEXT5sus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT5sus
	
	popa
	mov esp, ebp
	pop ebp
	ret
	
wsus:
	mov ecx, 0
	mov y, 0
	mov x, 0
	MARGUPwsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc x
	cmp ecx, 640
	jne MARGUPwsus
	
	mov ecx, 0
	mov y, 479  ;deviez un pixel mai jos
	mov x, 640
	MARGDOWNwsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec x
	cmp ecx, 640
	jne MARGDOWNwsus
	
	;cap
	mov ecx, 0	; linie jos-stanga
	mov eax, xcjs
	mov x, eax
	dec ycjs
	mov eax,ycjs
	mov y,eax
	NEXT1capjswsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capjswsus
	
	mov ecx, 0	;linie dreapta-jos
	mov eax, xcjd
	mov x, eax
	dec ycjd
	mov eax,ycjd
	mov y,eax
	NEXT1capjdwsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capjdwsus
	
	mov ecx, 0	; linie sus-dreapta
	mov eax, xcsd
	mov x, eax
	dec ycsd
	mov eax,ycsd
	mov y,eax
	NEXT1capsdwsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capsdwsus
	
	mov ecx, 0	; linie sus-stanga
	mov eax, xcss
	mov x, eax
	dec ycss
	mov eax,ycss
	mov y,eax
	NEXT1capsstwsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capsstwsus
	
	;mana stanga ridicata
	mov ecx, 100
	mov eax, xms
	mov x, eax
	dec yms
	mov eax,yms
	mov y,eax	
	NEXT1suswsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 150
	jne NEXT1suswsus
	
;mana dreapta ridicata
	mov ecx, 100
	mov eax, xmd
	mov x, eax
	dec ymd
	mov eax,ymd
	mov y,eax	
	NEXT2suswsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT2suswsus
	
	;line corp
	mov tmp, 0
	mov eax, xlc
	mov x, eax
	dec ylc
	mov eax,ylc
	mov y,eax
	NEXT3suswsus:
	mov eax, y	; muta sus-jos -y - +y
	mov ebx, area_width
	mul ebx
	add eax, x	;muta stanga-dreapta -x - +x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc tmp
	inc y
	cmp tmp, 110
	jne NEXT3suswsus
	
	;picior stanga
	mov ecx, 100
	mov eax, xps
	mov x, eax
	dec yps
	mov eax,yps
	mov y,eax
	NEXT4suswsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT4suswsus
	
	;picior dreapta
	mov ecx, 100
	mov eax, xpd
	mov x, eax
	dec ypd
	mov eax,ypd
	mov y,eax
	NEXT5suswsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT5suswsus
	
	popa
	mov esp, ebp
	pop ebp
	ret
	
stopJos:
	jmp desenare_init
	
muta_jos:
	cmp yps, 478			; verifica daca nu depaseste ecranul in partea inferioara
	jg stopJos
	
	cmp numarator, 0
	je ssus
	
	cmp numarator , 1
	je sjos
	
sjos:	
	mov ecx, 0
	mov y, 0
	mov x, 0
	MARGUPsjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc x
	cmp ecx, 640
	jne MARGUPsjos
	
	mov ecx, 0
	mov y, 479  ;deviez un pixel mai jos
	mov x, 640
	MARGDOWNsjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec x
	cmp ecx, 640
	jne MARGDOWNsjos
	
	;cap
	mov ecx, 0	; linie jos-stanga
	mov eax, xcjs
	mov x, eax
	inc ycjs
	mov eax,ycjs
	mov y,eax
	NEXT1capjssjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capjssjos
	
	mov ecx, 0	;linie dreapta-jos
	mov eax, xcjd
	mov x, eax
	inc ycjd
	mov eax,ycjd
	mov y,eax
	NEXT1capjdsjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capjdsjos
	
	mov ecx, 0	; linie sus-dreapta
	mov eax, xcsd
	mov x, eax
	inc ycsd
	mov eax,ycsd
	mov y,eax
	NEXT1capsdsjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capsdsjos
	
	mov ecx, 0	; linie sus-stanga
	mov eax, xcss
	mov x, eax
	inc ycss
	mov eax,ycss
	mov y,eax
	NEXT1capsstsjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capsstsjos
	
	;mana stanga
	mov ecx, 100
	mov eax, xms
	mov x, eax
	inc yms
	mov eax,yms
	mov y,eax
	NEXT1jos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	dec x
	cmp ecx, 150
	jne NEXT1jos
	
	;mana dreapta
	mov ecx, 100
	mov eax, xmd
	mov x, eax
	inc ymd
	mov eax,ymd
	mov y,eax
	NEXT2jos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT2jos
	
	;line corp
	mov tmp, 0
	mov eax, xlc
	mov x, eax
	inc ylc
	mov eax,ylc
	mov y,eax
	NEXT3jos:
	mov eax, y	; muta sus-jos -y - +y
	mov ebx, area_width
	mul ebx
	add eax, x	;muta stanga-dreapta -x - +x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc tmp
	inc y
	cmp tmp, 110
	jne NEXT3jos
	
	;picior stanga
	mov ecx, 100
	mov eax, xps
	mov x, eax
	inc yps
	mov eax,yps
	mov y,eax
	NEXT4jos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT4jos
	
	;picior dreapta
	mov ecx, 100
	mov eax, xpd
	mov x, eax
	inc ypd
	mov eax,ypd
	mov y,eax
	NEXT5jos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT5jos
	
	popa
	mov esp, ebp
	pop ebp
	ret
ssus:
	mov ecx, 0
	mov y, 0
	mov x, 0
	MARGUPssus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc x
	cmp ecx, 640
	jne MARGUPssus
	
	mov ecx, 0
	mov y, 479  ;deviez un pixel mai jos
	mov x, 640
	MARGDOWNssus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec x
	cmp ecx, 640
	jne MARGDOWNssus
	
	;cap
	mov ecx, 0	; linie jos-stanga
	mov eax, xcjs
	mov x, eax
	inc ycjs
	mov eax,ycjs
	mov y,eax
	NEXT1capjsssus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capjsssus
	
	mov ecx, 0	;linie dreapta-jos
	mov eax, xcjd
	mov x, eax
	inc ycjd
	mov eax,ycjd
	mov y,eax
	NEXT1capjdssus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capjdssus
	
	mov ecx, 0	; linie sus-dreapta
	mov eax, xcsd
	mov x, eax
	inc ycsd
	mov eax,ycsd
	mov y,eax
	NEXT1capsdssus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capsdssus
	
	mov ecx, 0	; linie sus-stanga
	mov eax, xcss
	mov x, eax
	inc ycss
	mov eax,ycss
	mov y,eax
	NEXT1capsstssus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capsstssus
	
	;mana stanga
	mov ecx, 100
	mov eax, xms
	mov x, eax
	inc yms
	mov eax,yms
	mov y,eax
	NEXT1ssus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 150
	jne NEXT1ssus
	
	;mana dreapta
	mov ecx, 100
	mov eax, xmd
	mov x, eax
	inc ymd
	mov eax,ymd
	mov y,eax
	NEXT2ssus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT2ssus
	
	;line corp
	mov tmp, 0
	mov eax, xlc
	mov x, eax
	inc ylc
	mov eax,ylc
	mov y,eax
	NEXT3ssus:
	mov eax, y	; muta sus-jos -y - +y
	mov ebx, area_width
	mul ebx
	add eax, x	;muta stanga-dreapta -x - +x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc tmp
	inc y
	cmp tmp, 110
	jne NEXT3ssus
	
	;picior stanga
	mov ecx, 100
	mov eax, xps
	mov x, eax
	inc yps
	mov eax,yps
	mov y,eax
	NEXT4ssus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT4ssus
	
	;picior dreapta
	mov ecx, 100
	mov eax, xpd
	mov x, eax
	inc ypd
	mov eax,ypd
	mov y,eax
	NEXT5ssus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT5ssus
	
	popa
	mov esp, ebp
	pop ebp
	ret
	
muta_st:
	cmp numarator, 0
	je stangasus
	
	cmp numarator , 1
	je stangajos
	
stangajos:
	mov ecx, 0
	mov y, 0
	mov x, 0
	MARGUPstjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc x
	cmp ecx, 640
	jne MARGUPstjos
	
	mov ecx, 0
	mov y, 479  ;deviez un pixel mai jos
	mov x, 640
	MARGDOWNstjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec x
	cmp ecx, 640
	jne MARGDOWNstjos
	
	;cap
	mov ecx, 0	; linie jos-stanga
	dec xcjs
	mov eax, xcjs
	mov x, eax
	mov eax,ycjs
	mov y,eax
	NEXT1capjsstjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capjsstjos
	
	mov ecx, 0	;linie dreapta-jos
	dec xcjd
	mov eax, xcjd
	mov x, eax
	mov eax,ycjd
	mov y,eax
	NEXT1capjdstjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capjdstjos
	
	mov ecx, 0	; linie sus-dreapta
	dec xcsd
	mov eax, xcsd
	mov x, eax
	mov eax,ycsd
	mov y,eax
	NEXT1capsdstjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capsdstjos
	
	mov ecx, 0	; linie sus-stanga
	dec xcss
	mov eax, xcss
	mov x, eax
	mov eax,ycss
	mov y,eax
	NEXT1capsststjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capsststjos
	
	;mana stanga
	mov ecx, 100
	dec xms
	mov eax, xms
	mov x, eax
	mov eax,yms
	mov y,eax
	NEXT1st:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	dec x
	cmp ecx, 150
	jne NEXT1st
	
	;mana dreapta
	mov ecx, 100
	dec xmd
	mov eax, xmd
	mov x, eax
	mov eax,ymd
	mov y,eax
	NEXT2st:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT2st

	;line corp
	mov tmp, 0
	dec xlc
	mov eax, xlc
	mov x, eax
	mov eax,ylc
	mov y,eax
	NEXT3st:
	mov eax, y	; muta sus-jos -y - +y
	mov ebx, area_width
	mul ebx
	add eax, x	;muta stanga-dreapta -x - +x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc tmp
	inc y
	cmp tmp, 110
	jne NEXT3st
	
	;picior stanga
	mov ecx, 100
	dec xps
	mov eax, xps
	mov x, eax
	mov eax,yps
	mov y,eax
	NEXT4st:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT4st
	
	;picior dreapta
	mov ecx, 100
	dec xpd
	mov eax, xpd
	mov x, eax
	mov eax,ypd
	mov y,eax
	NEXT5st:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT5st
	
	popa
	mov esp, ebp
	pop ebp
	ret
	
stangasus:
	mov ecx, 0
	mov y, 0
	mov x, 0
	MARGUPstsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc x
	cmp ecx, 640
	jne MARGUPstsus
	
	mov ecx, 0
	mov y, 479  ;deviez un pixel mai jos
	mov x, 640
	MARGDOWNstsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec x
	cmp ecx, 640
	jne MARGDOWNstsus
	
	;cap
	mov ecx, 0	; linie jos-stanga
	dec xcjs
	mov eax, xcjs
	mov x, eax
	mov eax,ycjs
	mov y,eax
	NEXT1capjsstsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capjsstsus
	
	mov ecx, 0	;linie dreapta-jos
	dec xcjd
	mov eax, xcjd
	mov x, eax
	mov eax,ycjd
	mov y,eax
	NEXT1capjdstsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capjdstsus
	
	mov ecx, 0	; linie sus-dreapta
	dec xcsd
	mov eax, xcsd
	mov x, eax
	mov eax,ycsd
	mov y,eax
	NEXT1capsdstsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capsdstsus
	
	mov ecx, 0	; linie sus-stanga
	dec xcss
	mov eax, xcss
	mov x, eax
	mov eax,ycss
	mov y,eax
	NEXT1capsststsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capsststsus
	
	;mana stanga
	mov ecx, 100
	dec xms
	mov eax, xms
	mov x, eax
	mov eax,yms
	mov y,eax
	NEXT1stsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 150
	jne NEXT1stsus
	
	;mana dreapta
	mov ecx, 100
	dec xmd
	mov eax, xmd
	mov x, eax
	mov eax,ymd
	mov y,eax
	NEXT2stsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT2stsus

	;line corp
	mov tmp, 0
	dec xlc
	mov eax, xlc
	mov x, eax
	mov eax,ylc
	mov y,eax
	NEXT3stsus:
	mov eax, y	; muta sus-jos -y - +y
	mov ebx, area_width
	mul ebx
	add eax, x	;muta stanga-dreapta -x - +x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc tmp
	inc y
	cmp tmp, 110
	jne NEXT3stsus
	
	;picior stanga
	mov ecx, 100
	dec xps
	mov eax, xps
	mov x, eax
	mov eax,yps
	mov y,eax
	NEXT4stsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT4stsus
	
	;picior dreapta
	mov ecx, 100
	dec xpd
	mov eax, xpd
	mov x, eax
	mov eax,ypd
	mov y,eax
	NEXT5stsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT5stsus
	
	popa
	mov esp, ebp
	pop ebp
	ret

muta_dr:
	cmp numarator, 0
	je dreaptasus
	
	cmp numarator , 1
	je dreaptajos
	
dreaptajos:
	mov ecx, 0
	mov y, 0
	mov x, 0
	MARGUPdrjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc x
	cmp ecx, 640
	jne MARGUPdrjos
	
	mov ecx, 0
	mov y, 479  ;deviez un pixel mai jos
	mov x, 640
	MARGDOWNdrjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec x
	cmp ecx, 640
	jne MARGDOWNdrjos
	
	;cap
	mov ecx, 0	; linie jos-stanga
	inc xcjs
	mov eax, xcjs
	mov x, eax
	mov eax,ycjs
	mov y,eax
	NEXT1capjsdrjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capjsdrjos
	
	mov ecx, 0	;linie dreapta-jos
	inc xcjd
	mov eax, xcjd
	mov x, eax
	mov eax,ycjd
	mov y,eax
	NEXT1capjddrjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capjddrjos
	
	mov ecx, 0	; linie sus-dreapta
	inc xcsd
	mov eax, xcsd
	mov x, eax
	mov eax,ycsd
	mov y,eax
	NEXT1capsddrjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capsddrjos
	
	mov ecx, 0	; linie sus-stanga
	inc xcss
	mov eax, xcss
	mov x, eax
	mov eax,ycss
	mov y,eax
	NEXT1capsstdrjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capsstdrjos
	
	;mana stanga
	mov ecx, 100
	inc xms
	mov eax, xms
	mov x, eax
	mov eax,yms
	mov y,eax
	NEXT1dr:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	dec x
	cmp ecx, 150
	jne NEXT1dr
	
	;mana dreapta
	mov ecx, 100
	inc xmd
	mov eax, xmd
	mov x, eax
	mov eax,ymd
	mov y,eax
	NEXT2dr:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT2dr

	;line corp
	mov tmp, 0
	inc xlc
	mov eax, xlc
	mov x, eax
	mov eax,ylc
	mov y,eax
	NEXT3dr:
	mov eax, y	; muta sus-jos -y - +y
	mov ebx, area_width
	mul ebx
	add eax, x	;muta stanga-dreapta -x - +x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc tmp
	inc y
	cmp tmp, 110
	jne NEXT3dr
	
	;picior stanga
	mov ecx, 100
	inc xps
	mov eax, xps
	mov x, eax
	mov eax,yps
	mov y,eax
	NEXT4dr:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT4dr
	
	;picior dreapta
	mov ecx, 100
	inc xpd
	mov eax, xpd
	mov x, eax
	mov eax,ypd
	mov y,eax
	NEXT5dr:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT5dr
	
	popa
	mov esp, ebp
	pop ebp
	ret
	
dreaptasus:
	mov ecx, 0
	mov y, 0
	mov x, 0
	MARGUPdrsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc x
	cmp ecx, 640
	jne MARGUPdrsus
	
	mov ecx, 0
	mov y, 479  ;deviez un pixel mai jos
	mov x, 640
	MARGDOWNdrsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec x
	cmp ecx, 640
	jne MARGDOWNdrsus
	
	;cap
	mov ecx, 0	; linie jos-stanga
	inc xcjs
	mov eax, xcjs
	mov x, eax
	mov eax,ycjs
	mov y,eax
	NEXT1capjsdrsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capjsdrsus
	
	mov ecx, 0	;linie dreapta-jos
	inc xcjd
	mov eax, xcjd
	mov x, eax
	mov eax,ycjd
	mov y,eax
	NEXT1capjddrsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capjddrsus
	
	mov ecx, 0	; linie sus-dreapta
	inc xcsd
	mov eax, xcsd
	mov x, eax
	mov eax,ycsd
	mov y,eax
	NEXT1capsddrsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capsddrsus
	
	mov ecx, 0	; linie sus-stanga
	inc xcss
	mov eax, xcss
	mov x, eax
	mov eax,ycss
	mov y,eax
	NEXT1capsstdrsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capsstdrsus
	
	;mana stanga
	mov ecx, 100
	inc xms
	mov eax, xms
	mov x, eax
	mov eax,yms
	mov y,eax
	NEXT1drsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 150
	jne NEXT1drsus
	
	;mana dreapta
	mov ecx, 100
	inc xmd
	mov eax, xmd
	mov x, eax
	mov eax,ymd
	mov y,eax
	NEXT2drsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT2drsus

	;line corp
	mov tmp, 0
	inc xlc
	mov eax, xlc
	mov x, eax
	mov eax,ylc
	mov y,eax
	NEXT3drsus:
	mov eax, y	; muta sus-jos -y - +y
	mov ebx, area_width
	mul ebx
	add eax, x	;muta stanga-dreapta -x - +x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc tmp
	inc y
	cmp tmp, 110
	jne NEXT3drsus
	
	;picior stanga
	mov ecx, 100
	inc xps
	mov eax, xps
	mov x, eax
	mov eax,yps
	mov y,eax
	NEXT4drsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT4drsus
	
	;picior dreapta
	mov ecx, 100
	inc xpd
	mov eax, xpd
	mov x, eax
	mov eax,ypd
	mov y,eax
	NEXT5drsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT5drsus
	
	popa
	mov esp, ebp
	pop ebp
	ret

muta_maini:

	cmp numarator, 0
	je jos
	cmp numarator, 1 
	je sus

sus:
	mov numarator, 0
	
	mov ecx, 0
	mov y, 0
	mov x, 0
	MARGUPsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc x
	cmp ecx, 640
	jne MARGUPsus
	
	mov ecx, 0
	mov y, 479  ;deviez un pixel mai jos
	mov x, 640
	MARGDOWNsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec x
	cmp ecx, 640
	jne MARGDOWNsus
	
	;cap
	mov ecx, 0	; linie jos-stanga
	mov eax, xcjs
	mov x, eax
	mov eax,ycjs
	mov y,eax
	NEXT1capjsmutatsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capjsmutatsus
	
	mov ecx, 0	;linie dreapta-jos
	mov eax, xcjd
	mov x, eax
	mov eax,ycjd
	mov y,eax
	NEXT1capjdmutatsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capjdmutatsus
	
	mov ecx, 0	; linie sus-dreapta
	mov eax, xcsd
	mov x, eax
	mov eax,ycsd
	mov y,eax
	NEXT1capsdmutatsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capsdmutatsus
	
	mov ecx, 0	; linie sus-stanga
	mov eax, xcss
	mov x, eax
	mov eax,ycss
	mov y,eax
	NEXT1capsstmutatsus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capsstmutatsus
	
	;mana stanga ridicata
	mov ecx, 100
	mov eax, xms
	mov x, eax
	mov eax,yms
	mov y,eax	
	NEXT1mutatSus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 150
	jne NEXT1mutatSus
	
	;mana dreapta ridicata
	mov ecx, 100
	mov eax, xmd
	mov x, eax
	mov eax,ymd
	mov y,eax	
	NEXT2mutatSus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT2mutatSus
	
	;line corp
	mov tmp, 0
	mov eax, xlc
	mov x, eax
	mov eax,ylc
	mov y,eax
	NEXT3mutatSus:
	mov eax, y	; muta sus-jos -y - +y
	mov ebx, area_width
	mul ebx
	add eax, x	;muta stanga-dreapta -x - +x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc tmp
	inc y
	cmp tmp, 110
	jne NEXT3mutatSus
	
	;picior stanga
	mov ecx, 100
	mov eax, xps
	mov x, eax
	mov eax,yps
	mov y,eax
	NEXT4mutatSus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT4mutatSus
	
	;picior dreapta
	mov ecx, 100
	mov eax, xpd
	mov x, eax
	mov eax,ypd
	mov y,eax
	NEXT5mutatSus:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT5mutatSus
		
	popa
	mov esp, ebp
	pop ebp
	ret
	
	
jos:
	mov numarator, 1

	mov ecx, 0
	mov y, 0
	mov x, 0
	MARGUPjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc x
	cmp ecx, 640
	jne MARGUPjos
	
	mov ecx, 0
	mov y, 479  ;deviez un pixel mai jos
	mov x, 640
	MARGDOWNjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec x
	cmp ecx, 640
	jne MARGDOWNjos
	
	;cap
	mov ecx, 0	; linie jos-stanga
	mov eax, xcjs
	mov x, eax
	mov eax,ycjs
	mov y,eax
	NEXT1capjsmutatjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capjsmutatjos
	
	mov ecx, 0	;linie dreapta-jos
	mov eax, xcjd
	mov x, eax
	mov eax,ycjd
	mov y,eax
	NEXT1capjdmutatjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capjdmutatjos
	
	mov ecx, 0	; linie sus-dreapta
	mov eax, xcsd
	mov x, eax
	mov eax,ycsd
	mov y,eax
	NEXT1capsdmutatjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	dec x
	cmp ecx, 25
	jne NEXT1capsdmutatjos
	
	mov ecx, 0	; linie sus-stanga
	mov eax, xcss
	mov x, eax
	mov eax,ycss
	mov y,eax
	NEXT1capsstmutatjos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 25
	jne NEXT1capsstmutatjos
	
	;mana stanga lasata
	mov ecx, 100
	mov eax, xms
	mov x, eax
	mov eax,yms
	mov y,eax
	NEXT1mutatJos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	dec x
	cmp ecx, 150
	jne NEXT1mutatJos
	
	;mana dreapta
	mov ecx, 100
	mov eax, xmd
	mov x, eax
	mov eax,ymd
	mov y,eax
	NEXT2mutatJos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT2mutatJos
	
	;line corp
	mov tmp, 0
	mov eax, xlc
	mov x, eax
	mov eax,ylc
	mov y,eax
	NEXT3mutatJos:
	mov eax, y	; muta sus-jos -y - +y
	mov ebx, area_width
	mul ebx
	add eax, x	;muta stanga-dreapta -x - +x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc tmp
	inc y
	cmp tmp, 110
	jne NEXT3mutatJos
	
	;picior stanga
	mov ecx, 100
	mov eax, xps
	mov x, eax
	mov eax,yps
	mov y,eax
	NEXT4mutatJos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	dec y
	inc x
	cmp ecx, 150
	jne NEXT4mutatJos
	
	;picior dreapta
	mov ecx, 100
	mov eax, xpd
	mov x, eax
	mov eax,ypd
	mov y,eax
	NEXT5mutatJos:
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov dword ptr [eax], 0FF0000h
	inc ecx
	inc y
	inc x
	cmp ecx, 150
	jne NEXT5mutatJos
	
	popa
	mov esp, ebp
	pop ebp
	ret
	
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int key);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
