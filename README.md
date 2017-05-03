# Assembly playground

## Assembly
Assembly, often abbreviated asm, is a low-level programming language for a computer, or other programmable device, in which there is a very strong (generally one-to-one) correspondence between the language and the architecture's machine code instructions.

## x64
x64 is a generic name for the 64-bit extensions to Intel's and AMD's 32-bit x86 instruction set architecture.

## Registers
Registers `rbp`, `rbx` and `r12` through `r15` "belong" to the calling function and the called function is required to preserve their values. In other words, a called function must preserve these registers’ values for its caller. Remaining registers "belong" to the called function. If a calling function wants to preserve such a register value across a function call, it must save the value in its local stack frame.

### `start` args
+ `[rsp]` - top of stack will contain arguments count.
+ `[rsp + 8]` - will contain argv[0]
+ `[rsp + 16]` - will contain argv[1]
+ and so on...

### Syscall args
+ `rdi` - used to pass 1st argument to functions
+ `rsi` - used to pass 2nd argument to functions
+ `rdx` - used to pass 3rd argument to functions
+ `rcx` - used to pass 4th argument to functions
+ `r8` - used to pass 5th argument to functions
+ `r9` - used to pass 6th argument to functions
+ (the kernel destroys `rcx` and `r11` after syscalls)

## Calling functions
+ `jmp <LABEL>` - jump to <LABEL>
+ `call <LABEL>` - push next instruction address onto stack and jump to <LABEL>
+ `ret` - pop value from stack and jump to address (combines with `call`)

## NASM
NASM is an assembler, there are others. Its syntax is designed to be simple and easy to understand, similar to Intel's but less complex.

## Useful links
+ https://software.intel.com/en-us/articles/introduction-to-x64-assembly
+ https://www.cs.uaf.edu/2006/fall/cs301/support/x86_64/
+ https://0xax.github.io/archive.html (series of posts on asm)
+ file:///Users/mgmcintyre/Downloads/x86-64-psABI-r252.pdf
+ https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf
+ http://myweb.lmu.edu/dondi/share/sp/nasm64.pdf
