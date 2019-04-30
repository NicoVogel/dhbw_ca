# Assembler

## function call's

The following is from source [1] and [2]. The described convention is called **cdecl**.

In this convention the caller is responsible for clearing the stack (passed parameters) after calling the function and the callee is responsible for its own stack frame. Also the callee should not override registers, except the return registers (AL, AX and DX).

````assembly
push arg3       ; push the parameter from last to first
push arg2
push arg1
call myfunc
add sp, 6       ; caller removes parameter from stack after call
````

### near function

Default setup for near functions, **bp** should not be modified in the function body.

````assembly
MyFunc:

    ; setup stack frame, bp can be used to reference parameters and local vars
    push    bp                           ; (1) save bp
    mov     bp, sp                       ; (2) set bp for referencing stack
    sub     sp, {local data size}        ; (3) allocate space for local variables
    ...
    ... <- function body
    ...
    mov     {return reg}, {return value} ; (4) set return value
    mov     sp, bp                       ; (5) free space used by local variables
    pop     bp                           ; (6) restore bp
    ret
````

> **Note 1**: If there are no local variables then there is no need to reserve space on the stack (step (3)). If there are no function arguments or local variables then it may not be necessary to set up and restore the stack frame (steps (1)-(3) and (5)-(6)). If there is no return value for a function then step (4) can be omitted.

> **Note 2**: If you change any value of an register (except the return register) *push* it before function body and *pop* it at the end.

The following c code is used as example for parameter and local variable accessing.

````c
int MyFunc(int arg1, int arg2, int arg3)
{
    int local1;
    int local2;
    int local3;
    ...
    ... <- function body
    ...
    return 3;
}
````

The following list shows how to access the parameters and local variables. In this case all integers need 2 byte, therefore a local data size of 6 applies.

Depending on the used variables and the required size, the calculation for the local data size changes.

````assembly
[bp+8] -> arg3
[bp+6] -> arg2
[bp+4] -> arg1
[bp+2] -> saved ip (return address)
[bp]   -> saved bp
[bp-2] -> local1
[bp-4] -> local2
[bp-6] -> local3

mov    dx, word [bp-4] ; load local2 into register dx
````

>The 8086 push instruction will only push 16-bit values

#### near function variables

| local Int               | local Char                                | local long                                    |
| ----------------------- | ----------------------------------------- | --------------------------------------------- |
| int local1;             | char local1;                              | long local1                                   |
| int local2;             | int  local2;                              | int  local2;                                  |
| ------------            | ------------                              | ------------                                  |
| [bp-2] -> local1 (word) | [bp-1] -> local1 (byte, [bp-2] is unused) | [bp-4] -> local1 (dword, [bp-2] is high word) |
| [bp-4] -> local2 (word) | [bp-4] -> local2 (word)                   | [bp-6] -> local2 (word)                       |

#### near function parameter

| param Int             | param Char                              | param Long                                   |
| --------------------- | --------------------------------------- | -------------------------------------------- |
| int arg1;             | char arg1;                              | long arg1;                                   |
| int arg2;             | int arg2;                               | int arg2;                                    |
| ------------          | ------------                            | ------------                                 |
| [bp+6] -> arg2 (word) | [bp+6] -> arg2 (word)                   | [bp+8]  -> arg2 (word)                       |
| [bp+4] -> arg1 (word) | [bp+4] -> arg1 (byte, [bp+5] is unused) | [bp+4]  -> arg1 (dword, [bp+6] is high word) |

#### near function return

````assembly
byte             al
word  (2 bytes)  ax
dword (4 bytes)  dx::ax (i.e., the high word in dx and the low word in ax).
````

### far function

A far call works in the same way as a near call, but the access for the parameter change. You have to add 2 to you default distance. The following shows the same list of how to access the parameters and local variables, but for far calls.

````assembly
[bp+10] -> arg3
[bp+8]  -> arg2
[bp+6]  -> arg1
[bp+4]  -> return CS (segment)
[bp+2]  -> return IP (offset)
[bp]    -> saved sp
[bp-2]  -> local1
[bp-4]  -> local2
[bp-6]  -> local3

````

## Array

````assembly

my_array db 5 dup (00h)
; same as
my_array db 00h, 00h, 00h, 00h, 00h

````


## Sources

[1] [The C Calling Convention and the 8086: Using the Stack Frame](http://ece425web.groups.et.byu.net/stable/labs/StackFrame.html)
[2] [x86 Assembly #9 - Calling Conventions | cdecl](https://www.youtube.com/watch?v=frqPX7EHscM)
[3] [8086+Assembly+programming](https://www.academia.edu/17747354/8086_Assembly_programming)