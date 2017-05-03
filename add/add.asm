; nasm -f macho64 add.asm && ld -macosx_version_min 10.7.0 -o bin/add add.o && bin/add 1 2

default rel     ; default to rip-relative addressing (vs. absolute)

section .data   ; home to initialised variables
    SYS_EXIT    equ     0x2000001   ; on OS X 64bit, syscalls are subsclassed, so 0x200000<id>
    SYS_WRITE   equ     0x2000004   ; 4 is write, 1 is exit
    EXIT_CODE   equ     0           ; we'll use this to exit at the end
    STD_OUT     equ     1           ; special file descriptor values

    NEW_LINE    db      0xa, 0x0    ; 0xa is unix LF, 0x0 is null byte

section .bss    ; home to uninitialised variables

section .text   ; home to instructions
    global start            ; export this so linker can see it (start is default entry point)

start:  ; args are on stack in order: path, *1st cli arg, *2nd cli arg, etc.
    pop     rcx                 ; argc
    add     rsp, 8              ; move rsp to point to argv[1] (argv[0] is path)

    pop     rsi                 ; load pointer to argv[1] into rsi
    call    str_to_int          ; function defined below, result will be in rax
    mov     r10, rax            ; store value in r10

    pop     rsi                 ; next argument
    call    str_to_int          ; function defined below, result will be in rax
    mov     r11, rax            ; store value in r11

    add     r10, r11            ; add r11 to r10
    mov     rax, r10            ; move r10 to rax
    xor     r12, r12            ; zero r12 to use as number counter below

    jmp     int_to_str          ; function defined below

str_to_int:
    xor     rax, rax            ; zero rax (faster than mov rax, 0)
    mov     rcx, 10             ; we'll use this to multiply by 10 as we find new numbers

next:
    cmp     [rsi], byte 0       ; compare value pointed to by rsi to single byte 0
    je      return_str          ; jump to return_string if above operation says they're equal
    mov     bl, [rsi]           ; store single byte at rsi to lower byte of rbx (bl)
    sub     bl, 48              ; subtract 48 to get int from ascii
    mul     rcx                 ; multiply rax by rcx, result stored in rdx:rax
    add     rax, rbx            ; add rbx to rax, where store the return value
    inc     rsi                 ; increment rsi to point to the next byte
    jmp     next                ; back to next label

return_str:
    ret                         ; return, uses rsp (stack pointer) for return address

int_to_str:
    mov     rdx, 0              ; set rdx to zero (required for div below)
    mov     rbx, 10             ; set rbx to 10
    div     rbx                 ; divide rax by rbx, ratio in rax, remainder in rdx
    add     rdx, 48             ; convert remainder int to ascii
    add     rdx, 0x0            ; strings must end with null byte
    push    rdx                 ; store character on stack
    inc     r12                 ; increment number counter to track length
    cmp     rax, 0x0            ; compare rax to 0
    jne     int_to_str          ; if rax isn't zero, we've got chars left
    jmp     print               ; otherwise print

print:
    mov     rax, 8              ; factor of 8 as we've pushed 1 byte values to 8 byte stack
    mul     r12                 ; multiply r12 by rax, result in rdx:rax
    mov     rdx, rax            ; move rax to rdx (3rd argument for syscall)

    mov     rax, SYS_WRITE      ; system write command
    mov     rdi, STD_OUT        ; arg 1 is STDOUT
    mov     rsi, rsp            ; arg 2 is address of string to print
    syscall                     ; call write (arg 3 is rdx, number of bytes to print)

    jmp printNewLine            ; print new line & exit


printNewLine:
    mov     rax, SYS_WRITE      ; sycall id
    mov     rdi, STD_OUT        ; fd to write to
    lea     rsi, [NEW_LINE]     ; load effective address of (rip relative) NEW_LINE
    mov     rdx, 1              ; # of bytes to write
    syscall                     ; call write(fd, *buf, bytes) (rdi, rsi, rdx)
    jmp     exit                ; jump to exit

exit:
    mov rax, SYS_EXIT           ; syscall id
    mov rdi, EXIT_CODE          ; exit code to return
    syscall                     ; call exit(code)
