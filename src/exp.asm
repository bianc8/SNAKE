include allmacro.txt

.model tiny

.data
;stringhe per la grafica
snake		 DB 'SNAKE$'
game 		 db 'GAME$'
over 		 db 'OVER$'
score  		 db 'Punteggio: $'
timit        db 'Tempo di gioco: 00:00$'
tutor0   	 db 'Per iniziare e spostarti usa i tasti WASD $'
tutor1		 db 'Schiva qualunque cosa non sia una caramella ',155,'$'
tutor2		 db 'Per uscire dal tutorial e iniziare a giocare premi il tasto Esc$'
tutt		 db '                                                               $'
premi 		 db 'Premi un tasto per tornare al menu...$'
premi2 		 db 'Premi un tasto per iniziare a giocare seriamente...$'
;stringhe per le tabelle

tabella 	 db '',218, 76 dup(196), 191, 0Dh, 0Ah
			 db 22 dup(179, 76 dup(32), 179, 0Dh, 0Ah)
			 db 192 , 76 dup (196), 217 , '$'
			 
menu    db '',218, 14 dup(196),191,13,10   
		db 33 dup(32),179,'    GIOCA     ',179,13,10
        db 33 dup(32),195,14 DUP(196),180,13,10
		db 33 dup(32),179,'   TUTORIAL   ',179,13,10
		db 33 dup(32),195,14 dup(196),180,13,10
		db 33 dup(32),179,'  CLASSIFICA  ',179,13,10
		db 33 dup(32),195,14 dup(196),180,13,10
		db 33 dup(32),179,'     ESCI     ',179,13,10
		db 33 dup(32),192,14 dup(196),217,'$'
	
menu_pausa    db '',218, 14 dup(196),191,13,10   
		db 33 dup(32),179,'    RIPRENDI    ',179,13,10
        db 33 dup(32),195,14 DUP(196),180,13,10
		db 33 dup(32),179,'   RICOMINCIA   ',179,13,10
		db 33 dup(32),195,14 dup(196),180,13,10
		db 33 dup(32),179,'     ESCI       ',179,13,10
		db 33 dup(32),192,14 dup(196),217,'$'					 
;grafica
caramella    db 155		;'*'
nemico		 db 240    ;'240'
;altro
lettprec 	 db ?
cont 		 db 4
posX 		 DB 8,7,6,5,196 dup(?)
posY 		 DB 12,12,12,12,196 dup(?)
div_x 		 DB 78
div_y 		 DB 24
div_nem_x	 DB 74
div_nem_y	 DB 24
x_car 		 DB ?
y_car 		 DB ?
x_nem		 DB ?
y_nem        DB ?
punteggio 	 db 0
contii       dw 0
contL        db 0
secondiUni   db 30h
secondiDec   db 30h
minutiUni    db 30h
minutiDec    db 30h
TempoRiga    DB 24
TempoColonna DB 70
x_pos        DB ?
y_pos        DB ?
flag		 DB 0
y			 DB ?
x			 DB ?
tutoll		 DB 0
.code
org 0100h
inizio:
	sfondo 0000h,184Fh,34h
	men
	sfondo 0000h,184Fh,72h
	sfondo 1800h,184Fh,40h
	sfondo 1810h,1811h,4Fh
	sfondo 1846h,184Bh,4Fh
	sfondo 1821h,1825h,4Fh
	posiziona 0,0
	scrivi_stringa tabella	
	nascondi
INIZIALIZZAZIONE:
	mov lettprec, 'd'
	posiziona 5, 24
	scrivi_stringa score
	posiziona 54,24
	scrivi_stringa timit
	posiziona 16, 24
	scrivi_char '0'  
	posiziona 33,24
	scrivi_stringa snake
	mov si, 0
	mov al, cont
	cbw
	mov cx, ax
loop_inizio:
	posiziona posX[si],posY[si]
	scrivi_char 219
	inc si
    loop loop_inizio
	
	random caramella,x_car,y_car
	jmp preMOVIMENTO
;jmp intermedi	
MEZs_premuto: jmp s_premuto
MEZd_premuto: jmp d_premuto
MEZfine:      jmp fine
MEZw_premuto: jmp w_premuto
;jmp intermedi
	
preMOVIMENTO:
	mov ah, 00h
	int 16h
	cmp al,'a'
	je MEZa_premuto2

	cmp al,'w' 
	je MEZw_premuto
	cmp al,'s'
	je MEZs_premuto
	cmp al,'d'
	je MEZd_premuto
	cmp al,27
	jne preMOVIMENTO
	jmp MEZfine 
;jmp intermedi
MEZa_premuto2: jmp a_premuto
;jmp intermedi  
MOVIMENTO:
	timer
	posiziona 16, 24
	stampa_punt punteggio
	
	cmp punteggio,5
	jb uno
	mov al,punteggio
	mov bh,5
	div bh
	cmp ah,0
	jne uno
	cmp flag,0
	jne uno
	random_nemici nemico,x_nem,y_nem
uno:
	mov ah,01h
	int 16h
	mov al,lettprec
	jz controlli
	mov ah, 00h
	int 16h
	jmp controlli
;jmp intermedi
MEZa_premuto:  jmp a_premuto
;jmp intermedi 
 	
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
	je MEZs_premuto6
skip3:
	cmp lettprec, 'a'
	je skip4
	cmp al,'d'
	je MEZd_premuto6
skip4:
	cmp al,27
	je MEZfine6 
  
	;cmp al,'p'
	;je menu_pausa
	jmp MOVIMENTO

;jmp intermedi
MEZmagna:       jmp magna
MEZfine6:       jmp fine
MEZs_premuto6:  jmp s_premuto
MEZd_premuto6:  jmp d_premuto
MEZfine5 :      jmp fine
mezMOVIMENTO6 : jmp MOVIMENTO
;jmp intermedi
 
w_premuto:		;▲
	mov lettprec, 'w'
	cmp al,'s'
	je mezMOVIMENTO6
	mov al,posx[0]
	mov ah,posy[0]
	dec ah
	posiziona al,ah
	mov ah,08h				;controlla nella posizione in cui sei che carattere c'è
	int 10h
	cmp al, caramella		  ; controllo_asterisco
	je MEZmagna
	cmp al,32
	jne MEZfine5
	ultimo
	sposta cont
	dec posy[0]
	posiziona posx[0],posy[0]
	scrivi_char 219

	cmp punteggio,70
	jae pc7
	cmp punteggio,45
	jae pc6
	cmp punteggio,30
	jae pc5
	cmp punteggio,15
	jae pc4
	cmp punteggio,5
	jae pc3
pc2:
	pa_lung_1
	jmp ww
pc3:
	pa_lung_2
	jmp ww
pc4:
	pa_lung_3
	jmp ww
pc5:
	pa_lung_4
	jmp ww
pc6:
	pa_lung_6
	jmp ww
pc7:
ww: 
	jmp MOVIMENTO
;jmp intermedi
mezMOVIMENTO: jmp MOVIMENTO
MEZfine2: 	  jmp fine
MEZmagna2:    jmp magna
;jmp intermedi 

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
	cmp al, caramella         ; controllo_asterisco
	je MEZmagna2
	cmp al,32
	jne MEZfine2
	ultimo
	sposta cont
	dec posx[0]
	posiziona posx[0],posy[0]
	scrivi_char 219
	
	cmp punteggio,70
	jae p7 
	cmp punteggio,45
	jae p6
	cmp punteggio,20
	jae p5
	cmp punteggio,15
	jae p4
	cmp punteggio,5
	jae p3
p2:
	pausa_1
	jmp aa
p3:
	pausa_2
	jmp aa
p4:
	pausa_3
	jmp aa
p5:
	pausa_4
	jmp aa
p6:
	pausa_6
	jmp aa
p7:
aa: 
    jmp MOVIMENTO

;jmp intermedi	
MEZfine3:         jmp fine
mezMOVIMENTO2:    jmp MOVIMENTO
MEZmagna3:        jmp magna
;jmp intermedi  
  
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
	cmp al, caramella			;controllo_asterisco
	je MEZmagna3
	cmp al,32
	jne MEZfine3
	ultimo
	sposta cont
	inc posy[0]
	posiziona posx[0],posy[0]
	scrivi_char 219

	cmp punteggio,70
	jae pac7
	cmp punteggio,45
	jae pac6
	cmp punteggio,20
	jae pac5
	cmp punteggio,15
	jae pac4
	cmp punteggio,5
	jae pac3
pac2:
	pa_lung_1
	jmp sss
pac3:
	pa_lung_2
	jmp sss
pac4:
	pa_lung_3
	jmp sss
pac5:
	pa_lung_4
	jmp sss
pac6:
	pa_lung_6
	jmp sss
pac7:
sss: 
	jmp MOVIMENTO
 
;jmp intermedi 
mezMOVIMENTO3:  jmp MOVIMENTO
MEZmagna4: jmp magna
MEZfine4 : jmp fine
;jmp intermedi  

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
	cmp al, caramella			; controllo_asterisco
	je MEZmagna4
	cmp al,32
	jne MEZfine4
	ultimo
	sposta cont
	inc posx[0]
	posiziona posx[0],posy[0]
	scrivi_char 219
	
	cmp punteggio,70
	jae pp7 
	cmp punteggio,45
	jae pp6
	cmp punteggio,20
	jae pp5
	cmp punteggio,15
	jae pp4
	cmp punteggio,5
	jae pp3
pp2:
	pausa_1
	jmp ddd
pp3:
	pausa_2
	jmp ddd
pp4:
	pausa_3
	jmp ddd
pp5:
	pausa_4
	jmp ddd
pp6:
	pausa_6
	jmp ddd
pp7:
ddd: 
	jmp MOVIMENTO
  
  
magna:
	inc punteggio
	inc cont
	sposta cont
	mov ah, x_car
	mov posX[0], ah
	mov ah, y_car
	mov posY[0], ah
	posiziona x_car, y_car
	scrivi_char 219
	random caramella,x_car,y_car
	pausa
	mov flag,0
	jmp movimento

	
fine:
	sfondo 071Eh, 1031h, 4Fh
	posiziona 38, 11
	scrivi_stringa game
	posiziona 38,12
	scrivi_stringa over
	sfondo 0516h,053Ah,0FFh
	posiziona 22,5
	scrivi_stringa premi
	mov ah,07h
	int 21h
	pulisci POSx,POSy
	jmp inizio
end inizio