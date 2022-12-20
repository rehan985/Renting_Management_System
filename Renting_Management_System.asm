
;                           =============================================================================
;                           =---------------- Computer Organization & Assembly Language ----------------=
;                           =============================================================================

;                           =============================================================================
;                           =------------------------------ Term Project -------------------------------=
;                           =--------------------- RENTING MANAGEMENT SYSTEM ---------------------=
;                           =------------------------------ Group Members ------------------------------=
;                           =-------------- M.AASHIR ------ REHAN AKHTAR ------DAWOOD IMTIAZ---------=
;                           =--------------- 210950 ---------- 210953 ------------ 211022 ------------------=
;                           =============================================================================

include newline.lib  ; library include which contain macro 

RENT struct      ; structure is used 

Time dw 0       ;Time the vehicle was parked

RENT ends

.model large
.data       ;Data Segment

Fname db "RENT.txt",0     ; file name 
buffer db 42 dup ('$')
handle dw 0
digitCount db 0
name1 db 30 dup(?)     ; array's 
model1 db 10 dup(?)

enteredNumber dw 0
temp1 dw 0     ; menu start 
menu db "				---------MENU--------$"
menu1 db "			Press 1 for Bike(Rs. 50 per Hour) $"
menu2 db "			Press 2 for Car(Rs. 250 per Hour) $"
menu3 db "			Press 3 for Bus(Rs. 500 per Hour) $"
menu4 db "			Press 1 to Print Records $"
menu5 db "			Your Bill: Rs. $"
menu6 db "			Press 6 to Exit $"
menu7 db "			Your Choice: $"
menu8 db "		       Enter the time of your Vehicle(in hours): $"
menu9 db "           		press 4 to main menu $"
F1 db "renting is Full $"
F2 db '			Name: ','$'
F3 db '			Model: $'
F4 db '	   		Time: $'
space db 6      ; menu end 

vehicle RENT <>			;vehicle as an object

.code

main proc

mov ax, @data
mov ds, ax

;graphics
	mov ah,0
	mov al,03h
	int 10h
	
	mov ah, 06h
	mov cx, 0017h
	mov dx, 0540h
	mov bh, 30h
	mov al, 0
	int 10h
	
	mov ah, 6h
	mov cx, 0617h
	mov dx, 2650h
	mov bh, 3h
	mov al, 0
	int 10h       ; graphics 

X1:
    call Input
	

Input PROC
    mov ah,9
    lea dx, menu 
    int 21h

    newLine			;macro

    mov ah, 9          ; show menu 
    lea dx, menu1
    int 21h
    newLine
    mov ah,9
    lea dx, menu2 
    int 21h
    newLine 
    mov ah,9
    lea dx, menu3
    int 21h
    newLine

    mov ah,9
    lea dx, menu6
    int 21h
    newLine

    mov ah, 9
    lea dx, menu7
    int 21h
	                             ; menu end 
;Input
    mov ah, 1
    int 21h
    sub al, 48

    .if al == 1
        newLine
        call INPUT_NAME			;to input name
        call INPUT_MODEL		;to input model
		call File                ; store in file 
        mov al, 1
        mov ah, 0
        call Entry
    .endif

    .if al == 2
        newLine
        call INPUT_NAME			;to input name	
        call INPUT_MODEL		;to input model
		call File
        mov al, 2
        mov ah, 0
        call Entry
    .endif

    .if al == 3
        newLine
        call INPUT_NAME			;to input name
        call INPUT_MODEL		;to input model
		call File
        mov al, 3
        mov ah, 0
        call Entry 
    .endif
	    mov ah, 1
    int 21h
    sub al, 48

    .if al == 4         ;back to main
       call main
    .endif


    .if al == 6			;exit
        jmp exit
    .endif
exit:	
mov ah,4ch
	int 21h 

    ret
Input ENDP

;description
Entry PROC
    push ax
    newLine
    newLine
    mov ah,2
    lea dx, menu8
    int 21h
	

    pop ax

    .if ax == 1
        mov ah,9
        lea dx, menu8 
        int 21h

        call DD_Input
        newLine
        newLine

        mov ah,9
        lea dx, menu5
        int 21h
		
        mov ax, [enteredNumber]
        mov vehicle.Time, ax
        mov dx, 50
        mul dx

        mov enteredNumber, ax
        call DD_Output
      
    .endif

    .if ax == 2
        mov ah,9
        lea dx, menu8 
        int 21h

        call DD_Input
        newLine
        newLine

        mov ah,9
        lea dx, menu5
        int 21h


        mov ax, [enteredNumber]
        mov vehicle.Time, ax
        mov dx, 250
        mul dx


        mov enteredNumber, ax
        call DD_Output
        
    .endif

    .if ax == 3
        mov ah,9
        lea dx, menu8 
        int 21h

        call DD_Input
        newLine
        newLine

        mov ah,9
        lea dx, menu5
        int 21h

        mov ax, [enteredNumber]
        mov vehicle.Time, ax
        mov dx, 500
        mul dx

        mov enteredNumber, ax
        call DD_Output
     

    .endif
ret 
Entry ENDP

;This Function takes double digit Input
DD_Input PROC

    inn:
        mov ah, 01
        int 21h
        cmp al, 13
        je go

        sub al, 48
        mov ah, 0
        mov temp1, ax
        mov ax, 0
        mov ax, enteredNumber
        mov bl, 10
        mul bl
        add ax, temp1
        mov enteredNumber, ax
        jmp inn

    go:
    
    ret
DD_Input ENDP

;Double Digit Output
DD_Output PROC
    mov digitCount, 1
    mov cx, 0

    Divide:
        cmp digitCount, 0
        je Display 
        mov ax, enteredNumber
        mov bl, 10
        div bl 
        mov dx, 0
        mov dl, ah
        push dx
        inc cx
        mov ah,0
        mov digitCount, al 
        mov enteredNumber, ax

        jmp  Divide

    Display:
        pop dx
        add dx, 48
        mov ah, 2
        int 21h

    loop Display
    newLine
	  newLine

	mov ah, 9
    lea dx, menu9
    int 21h
    newLine

    mov ah,9
    lea dx, menu6
    int 21h
    newLine

    ret
DD_Output ENDP

;This procedure will Input Name of Vehicle 
INPUT_NAME PROC
    
    mov cx, lengthof name1
    mov si, 0
    mov si, offset name1

    mov ah,9
    lea dx, F2 
    int 21h

    l1:
        mov ah,1
        int 21h
        cmp al,13
        je return1

        mov [si], al
        inc si
    
    loop l1

    return1:
        newLine
        mov cx, 0
        mov si, 0
        ret 
INPUT_NAME ENDP


;This procedure will Input Model of Vehicle
INPUT_MODEL PROC
    
    mov cx, lengthof model1
    mov si, 0
    mov si,offset model1

    mov ah,9
    lea dx, F3
    int 21h

    l2:
        mov ah,1
        int 21h
        cmp al,13
        je return2

        mov [si], al
        inc si
    
    loop l2

    return2:
        newLine
        mov cx, 0
        mov si, 0
        ret 
INPUT_MODEL ENDP

;---------------------------------------------------------------file handling
File PROC
    mov dx,offset Fname
mov al,2
mov ah,3dh     ; open file 
int 21h
mov handle,ax     ;move to the handle 

mov ah,42h         ; append mode 
mov al,2           ; mode 
mov bx,handle
mov cx,0
mov dx,0            ; 
int 21h

mov si, 0
mov bx, 0
mov cx, lengthof name1

gogo1:
cmp name1[si], '$'    ; end of name 
JE jen1
mov al, name1[si]
mov buffer[bx], al    ; move name to the buffer 
jen1:                 ; add space 
inc si
inc bx
loop gogo1

mov si, 0
mov cx, lengthof model1

gogo2:
cmp model1[si], '$'
JE jen2
mov al, model1[si]
mov buffer[bx], al
jen2:
inc si
inc bx
loop gogo2

mov buffer[bx], 0Dh      ; add enter in the file 
inc bx  
mov buffer[bx], 0Ah
inc bx

mov cx,lengthof buffer      ; 
mov bx,handle
mov dx,offset buffer        ; add buffer to the file 
mov ah,40h                  ; write mode 
int 21h

mov ah, 3eh                  ; close file 
mov bx, handle
int 21h

    ret
File ENDP

mov cx, lengthof buffer         ; clear the buffer 
mov bx, 0
looper1:
mov buffer[bx], ' '
inc bx
loop looper1

mov cx, lengthof name1         ; clear the name variable 
mov bx, 0
looper2:
mov name1[bx], ' '
inc bx
loop looper2

mov cx, lengthof model1       ; clear the model variable 
mov bx, 0
looper3:
mov model1[bx], ' '
inc bx
loop looper3


main endp
end main