; mov [spremenljivka_v_bss],eax <-- shranimo vrednost na naslovu od spremenljivke
; klicanje printfa
; psush ecx <-- vrednost
; push format_string <--- naslov format stringa
; call printf <-- klic funkcije
; add esp, 8 <-- argumenta sta zavzela 2x po 4 bajte ker smo v 32-bitnem modu oz smo uporabili 32 bitne registre

; Define variables in the data section
SECTION .DATA ; section that creates initialized variables
    sysdir:    db 'SysDir',0
    filename:  db 'PidTimeData.dat',0
    format:    db '%d %d',10,0

SECTION .bss; section that reserves data for variables (uninitialized data)
    fd         resd  1
    pid        resd  1
    time       resd  1

; Code goes in the text section
SECTION .TEXT
	GLOBAL _start 
    extern dprintf

_start:
    mov eax,0x27         ; mkdir syscal
    mov ebx,sysdir
    mov ecx,0o764        ; rwxrw-r--
    int 0x80

    mov eax,0x0c         ; chdir
    mov ebx,sysdir
    int 0x80

    mov eax,0x05         ; open
    mov ebx,filename
    mov ecx,2|64|512
    mov edx,0o640        ; rw-r-----
    int 0x80
    mov [fd],eax         ; shrani fd v fd spremenljivko
    
    mov eax,0x14         ; getpid
    int 0x80
    mov [pid],eax        ; store pid into pid var

    mov eax,0x0d         ; time
    mov ebx,time         ; addres to time variable
    int 0x80

    push dword[time]     ; store the value of time as last arg
    push dword[pid]      ; store the value of pid as arg
    push format          ; store ptr to format string as arg
    push dword[fd]       ; store value of fd as arg
    call dprintf
    add esp,16           ; move stack pointer back 16 to free space that args have taken up

    mov eax,0x06
    mov ebx,[fd]
    int 0x80

	mov eax,1            ; exit
    xor ebx,ebx          ; exit code 0
	int 0x80

