TITLE Lab7	

IDEAL
MODEL SMALL
STACK 256

;---Макрос затримки часу(time/45 ~ кількість секунд)----------------------
MACRO delay time
	push cx
	mov cx, time
outer:
	push cx
	mov cx, 0FFFFh
	loop $
	pop cx
	loop outer
	pop cx
ENDM	


DATASEG
newLine db 13,10, '$'
time EQU 130
divider EQU 2705   ; 1190000 МГц / 440 Гц = 2705 

a1 DB -7
a2 DB 3
a3 DB 2
a4 DB 4
a5 DB 3

message_0 DB "Welcome to team3's lab7!!", 13, 10, '$'
message_1 DB "Press 'y' to compute equation", 13, 10, '$'
message_2 DB "Press 'U' to play BEEEEEEEP for 3 seconds", 13, 10, '$'
message_3 DB "Press 'i' to exit", 13, 10, '$'
message_4 DB "Good bye! Thank you for using our super-puper application.  We hope you enjoyed BEEEEEEEP", 13, 10, '$'


CODESEG
;---Процедура виводу повідомлення у консоль-------------------------------
PROC display_message
	mov ah, 09h
	int 21h
	ret
ENDP 
;---Перехід у відео мод---------------------------------------------------
PROC clear_screen
	mov ah, 0
	mov al, 3
	int 10h
	ret
ENDP 
;---Вивід інформації для користувача--------------------------------------
PROC display_user_info
	call clear_screen
	mov dx, offset message_0
	call display_message
	mov dx, offset message_1
	call display_message
	mov dx, offset message_2
	call display_message
	mov dx, offset message_3
	call display_message
	ret
ENDP
;---Отримання символу від користувача-------------------------------------
PROC get_input
	mov ah, 08h
	int 21h
	ret
ENDP 
;---Точка входу у програму------------------------------------------------
Start:
;---Ініціалізація датасегмента та додаткового сегмента--------------------
	mov ax, @data
	mov ds, ax
	mov es, ax
	
	call display_user_info	
	;--Головний цикл програми---------------------------------------------
	main_loop:
		
		call get_input	
		
		cmp al, 'y'
		je Calculate
		
		cmp al, 'U'
		je Beep
		
		cmp al, 'i'
		je Exit
		
		call display_user_info	
		jmp main_loop
	;---Ввімкнення звуку на 3 секунди-------------------------------------
	Beep:	
		
		;---Задання дільника частоти системного таймеру-------------------
		mov ax, divider
		out 42h, al
		mov al, ah
		out 42h, al
		
		;---Перевід динаміку у ввімкнений стан----------------------------
		in al, 61h
		or al, 3
		out 61h, al
		
		delay time
		
		;---Перевід динаміка у вимкнений стан-----------------------------
		and al, 11111100b
		out 61h, al

	jmp main_loop
	;---Обчислення виразу-------------------------------------------------
	Calculate:
		call display_user_info	
		mov ah, [a1]
		mov al, [a2]
		add al, ah      ;al = al + ah
		
		mov ah, [a3]	
		imul ah         ;ax = al * ah

		mov bl, [a4]
		idiv bl         ;al = ax / bl
			
		mov ah, [a5]
		add al, ah      ;al = al + ah
		
		mov ah, 02h     ;команда виводу символу
		mov dl, al		
		add dl, 30h		;dl + 48 = ASCII-код 
		int 21h
		
		mov ah, 09h           
		mov dx, offset newLine
		int 21h 
	jmp main_loop
	;---Завершення програми-----------------------------------------------
	Exit:	
		call display_user_info	
		mov dx, offset message_4
		call display_message
		mov ah, 4ch
		mov al, 0
		int 21h
end Start



















