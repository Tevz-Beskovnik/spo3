; Define variables in the data section
SECTION .DATA ; section that creates initialized variables
	hello:     db 'Hello world!',10
	helloLen:  equ $-hello
    sysdir:    db 'SysDir',0
    sysdirLen: equ $-sysdir
    filename:  db 'PidTimeData.dat',0

SECTION .BSS ; section that reserves data for variables (uninitialized)

; Code goes in the text section
SECTION .TEXT
	GLOBAL _start 

_start:
;	mov eax,4            ; 'write' system call = 4
;	mov ebx,1            ; file descriptor 1 = STDOUT
;	mov ecx,hello        ; string to write
;	mov edx,helloLen     ; length of string to write
;	int 80h              ; call the kernel
    mov eax,0x27         ; mkdir syscal
    mov ebx,sysdir
    mov ecx,0o764        ; rwxrw-r--
    int 0x80

    mov eax,0x0c         ; chdir
    mov ebx,sysdir
    int 0x80

; mov [spremenljivka_v_bss],eax <-- shranimo vrednost na naslovu od spremenljivke
; klicanje printfa
; psush ecx <-- vrednost
; push format_string <--- naslov format stringa
; call printf <-- klic funkcije
; add esp, 8 <-- argumenta sta zavzela 2x po 4 bajte ker smo v 32-bitnem modu oz smo uporabili 32 bitne registre
    mov eax,0x08         ; create
    mov ebx,filename
    mov ecx,0o640        ; rw-r-----
    int 0x80

    mov eax,0x05         ; open

	; Terminate program
	mov eax,1            ; 'exit' system call
    xor ebx,ebx            ; exit with error code 0
	int 0x80              ; call the kernel


