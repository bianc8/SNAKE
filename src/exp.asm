include allmacro.txt

.model tiny

.data

tabella db '',218, 76 dup(196), 191, 0Dh, 0Ah
		db 22 dup(179, 76 dup(32), 179, 0Dh, 0Ah)
		db 192 , 76 dup (196), 217 , '$'
game db 'GAME$'
over db 'OVER$'
lettprec db ?
cont db 4
posX DB 8,7,6,5,96 dup(?)
posY DB 12,12,12,12,96 dup(?)
div_x 		DB 78
div_y 		DB 24
x_car 		DB ?
y_car 		DB ?
caramella db 155		;ø

.code
org 0100h

inizio:

programma:



mov ax,0b800h
    mov es,ax        ; set es to text video memory segment
    xor di,di        ; starting offset = 0 for stosw
    mov cx,2000      ; 2000 2-byte (16-bit word) cells on an 80x25 display
    mov ax, 7220h     ; 20h = ascii value for space character
                     ; 1fh = attribute (white on blue)
    cld              ; set direction flag forward (used by stosw etc)
	rep stosw 
	
	posiziona 0,0

	scrivi_stringa tabella	
	
	nascondi

INIZIALIZZAZIONE:

  mov lettprec, 'd'

  mov si, 0
  mov al, cont
  cbw
  mov cx, ax

  loop_inizio:

	posiziona posX[si],posY[si]
	scrivi_char 219
	inc si
	
    loop loop_inizio
	
	random
	
	jmp preMOVIMENTO
	MEZa_premuto:
	jmp a_premuto
	
	MEZs_premuto:
	jmp s_premuto
	
	MEZd_premuto:
	jmp d_premuto
	
	MEZfine:
	jmp fine
	
preMOVIMENTO:

  mov ah, 00h
  int 16h
 
  cmp al,'w' 
  je w_premuto

  cmp al,'a'
  je MEZa_premuto
    
  cmp al,'s'
  je MEZs_premuto
  
  cmp al,'d'
  je MEZd_premuto

  cmp al,27
  jne preMOVIMENTO
  jmp MEZfine 


MOVIMENTO:

  mov ah,01h
  int 16h
  mov al,lettprec
  
  jz controlli
  
  mov ah, 00h
  int 16h
  	
controlli:	
	
  cmp lettprec, 's'
  je skip

  cmp al,'w' 
  je w_premuto

skip:

  cmp lettprec, 'd'
  je skip2
  
  cmp al,'a'
  je MEZa_premuto
  
skip2:

  cmp lettprec, 'w'
  je skip3
  
  cmp al,'s'
  je MEZs_premuto
  
skip3:
  
  cmp lettprec, 'a'
  je skip4
  
  cmp al,'d'
  je MEZd_premuto
  
skip4:
  
  cmp al,27
  je MEZfine 

  jmp MOVIMENTO
  
  ; cmp al,'p'
  ; je menu_pausa

MEZmagna: jmp magna

MEZfine5 : jmp fine
  
w_premuto:		;▲

  mov lettprec, 'w'
   
  cmp al,'s'
  je MOVIMENTO
  
  mov al,posx[0]
  mov ah,posy[0]
  
  dec ah
  
  posiziona al,ah
  
  mov ah,08h				;controlla nella posizione in cui sei che carattere c'è
  int 10h
  
  ; controllo_asterisco
  cmp al, caramella
  je MEZmagna
  
  cmp al,32
  jne MEZfine5
  
  ultimo
  
  sposta cont
  
  dec posy[0]
  
  posiziona posx[0],posy[0]
  
  ; scrivi_char 30
   scrivi_char 219
  ;scrivi_corpo
  
  pausa_piu_lunga			;pausa_piu_lunga
  
  jmp MOVIMENTO
  
 mezMOVIMENTO:
 jmp MOVIMENTO
 
  mezpreMOVIMENTO:
 jmp preMOVIMENTO
 
 MEZfine2: 
 jmp fine
 
MEZmagna2: jmp magna
 
a_premuto:			;◄

  mov lettprec, 'a'
   
  cmp al,'d'
  je mezMOVIMENTO 
  
  
  mov al,posx[0]
  mov ah,posy[0]
  
  dec al
  
  posiziona al,ah
  
  mov ah,08h				;controlla nella posizione in cui sei che carattere c'è
  int 10h
  
  ; controllo_asterisco
  cmp al, caramella
  je MEZmagna2
  
  cmp al,32
  jne MEZfine2
  
  ultimo
  
  sposta cont
  dec posx[0]
  
  posiziona posx[0],posy[0]
  
;  scrivi_char 17
 scrivi_char 219
 ; scrivi_corpo
  
  pausa
  
  jmp MOVIMENTO
  
  MEZfine3:
  jmp fine
  
  mezMOVIMENTO2:
  jmp MOVIMENTO
  
  mezpreMOVIMENTO2:
 jmp preMOVIMENTO
 
 MEZmagna3: jmp magna
  
  
s_premuto:			;▼

  mov lettprec, 's'
   
  cmp al,'w'
  je mezMOVIMENTO2
  
  mov al,posx[0]
  mov ah,posy[0]
  
  inc ah
  
  posiziona al,ah
  
  mov ah,08h				;controlla nella posizione in cui sei che carattere c'è
  int 10h
  
  ; controllo_asterisco
  
  cmp al, caramella
  je MEZmagna3
  
  cmp al,32
  jne MEZfine3
  
  ultimo
  
  sposta cont
  inc posy[0]
  
  posiziona posx[0],posy[0]
  
  ; scrivi_char 31
   scrivi_char 219
 ; scrivi_corpo
  
  pausa_piu_lunga
 
  jmp MOVIMENTO
  
  mezMOVIMENTO3:
  jmp MOVIMENTO
  
   mezpreMOVIMENTO3:
 jmp preMOVIMENTO
 
  MEZmagna4: jmp magna
  
  MEZfine4 : jmp fine
  
d_premuto:		;►

  mov lettprec, 'd'
   
  cmp al,'a'
  je mezMOVIMENTO3
  
  mov al,posx[0]
  mov ah,posy[0]
  
  inc al
  
  posiziona al,ah
  
  mov ah,08h				;controlla nella posizione in cui sei che carattere c'è
  int 10h
  
  ; controllo_asterisco
  cmp al, caramella
  je MEZmagna4
  
  cmp al,32
  jne MEZfine4
  
  ultimo
  
  sposta cont
  
  inc posx[0]
  
  posiziona posx[0],posy[0]
  
 ; scrivi_char 16
 scrivi_char 219
  
 ; scrivi_corpo
  
  pausa

  jmp MOVIMENTO
  
  
magna:
	inc cont
	sposta cont
	mov ah, x_car
	mov posX[0], ah
	mov ah, y_car
	mov posY[0], ah
	posiziona x_car, y_car
	scrivi_char 219
	random
	pausa
  jmp movimento
  
fine:

posiziona 0,23

mov ah, 4ch
int 21h

end inizio