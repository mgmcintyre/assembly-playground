; nasm -f macho64 hello.asm && ld -macosx_version_min 10.7.0 -o bin/hello hello.o && bin/hello

section .data
    msg:    db      "Hello, world!", 0x0A   ; msg is now memory address of this string
    .len:   equ     $ - msg                 ; msg.len is now constant length of msg in bytes

section .text
    global start

start:
    mov     rax, 0x2000004  ; write command (syscall will execute the command referenced in rax)
    mov     rdi, 1          ; stdout
    mov     rsi, msg        ; *buffer
    mov     rdx, msg.len    ; bytes to print
    syscall

    mov     rax, 0x2000001  ; exit command
    mov     rdi, 0          ; return code
    syscall
