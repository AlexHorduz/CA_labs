IDEAL        ;директива - тип ассемблера tasm
MODEL SMALL  ;директива - тип моделі пам'яті
STACK 256    ;директива - розмір стеку

DATASEG                ;початок сегменту даних
rect_word db 34h, 33h  ;word, що ми будемо завантажувати у відеопам'ять 
x_coord db 02h         ;x-координата лівого верхнього кута прямокутника(0-based)
y_coord db 0Ah         ;y-координата лівого верхнього кута прямокутника(0-based) 
exCode db 00           ;код виходу

CODESEG                ;початок сегменту коду
Start:
	mov ax, @data	  ;@data ідентифікатор, що створюються директивою model
	mov ds, ax        ;Завантаження початку сегменту даних в регістр ds
	mov dx, 80*2      ;dx = 160
	mov al, 80*2      ;al = 160
	mul [y_coord]     ;ax = al * y_coord
	add dx, ax        ;dx = dx + ax
	mov al, 2	      ;al = 2
	mul [x_coord]     ;ax = al * x_coord
	add dx, ax        ;dx = dx + ax
	mov ax, 0B800h    ;Завантаження початку адреси відеопам'яті в регістр ax
	mov es, ax		  ;Завантаження вмісту регістру ax у регістр es 		  
	mov di, dx        ;Завантаження вмісту регістру dx у регістр di
	mov ah, [offset rect_word]        ;завантаження 1-го байту rect_word у першу частину регістру ax
	mov al, [offset rect_word + 1]    ;завантаження 2-го байту rect_word у другу частину регістру ax
	
	mov cx, 10                         ;cx = 10
	loop1:                             ;мітка
		mov dx, cx                     ;dx = cx
		mov cx, 20                     ;cx = 20
		loop2:		                   ;мітка
			mov [es:di], ax            ;завантаження у відеопам'ять слова ax
			inc di                     ;dx += 1
			inc di                     ;dx += 1
			loop loop2                 ;повернення до мітки
		add di, (80-20)*2              ;di += 60*2
		mov cx, dx                     ;cx = dx
		loop loop1                     ;повернення до мітки
		
	mov ah, 4ch         ; Завантаження числа 4ch до регістру ah (Функція DOS 4ch - виходу з програми)
	mov al, [exCode]    ;отримання коду виходу 
	int 21h             ;виклик функції DOS 4ch
	end Start  
	


