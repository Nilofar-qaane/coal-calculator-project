; Updated Calculator.asm - A simple calculator with continuous operation loop

INCLUDE Irvine32.inc

.data
    ; Constants for prompt messages
    prompt1 BYTE "Enter the first number: ", 0
    prompt2 BYTE "Enter the second number: ", 0
    promptOp BYTE "Enter the operation (+, -, *, /): ", 0
    errorMsg BYTE "Error: Division by zero is not allowed.", 0
    resultMsg BYTE "The result is: ", 0
    continueMsg BYTE "Do you want to perform another calculation? (y/n): ", 0
    invalidMsg BYTE "Invalid input. Exiting the program.", 0
    inputStr BYTE 20 DUP(0)
    op BYTE ?
    continue BYTE ?

.code
main PROC
    call Clrscr
    CONTINUE_CALC:
    ; Get first number
    mov edx, OFFSET prompt1
    call WriteString
    call ReadInt
    mov ebx, eax ; store first number in ebx

    ; Get second number
    mov edx, OFFSET prompt2
    call WriteString
    call ReadInt
    mov ecx, eax ; store second number in ecx

    ; Get operation
    mov edx, OFFSET promptOp
    call WriteString
    call ReadChar
    mov op, al

    ; Perform calculation
    cmp op, '+'
    je ADD_OP
    cmp op, '-'
    je SUB_OP
    cmp op, '*'
    je MUL_OP
    cmp op, '/'
    je DIV_OP

    ; Invalid operation
    jmp END_CALC

ADD_OP:
    add ebx, ecx
    jmp DISPLAY_RESULT

SUB_OP:
    sub ebx, ecx
    jmp DISPLAY_RESULT

MUL_OP:
    imul ebx, ecx
    jmp DISPLAY_RESULT

DIV_OP:
    cmp ecx, 0
    je DIV_ERROR
    cdq ; sign extend EAX into EDX:EAX
    idiv ecx
    mov ebx, eax ; store the result in ebx
    jmp DISPLAY_RESULT

DIV_ERROR:
    mov edx, OFFSET errorMsg
    call WriteString
    jmp END_CALC

DISPLAY_RESULT:
    mov eax, ebx
    mov edx, OFFSET resultMsg
    call WriteString
    call WriteInt
    call Crlf

    ; Ask if user wants to continue
    mov edx, OFFSET continueMsg
    call WriteString
    call ReadChar
    mov continue, al
    cmp continue, 'y'
    je CONTINUE_CALC
    cmp continue, 'n'
    je END_PROGRAM

    ; Invalid input handling
    mov edx, OFFSET invalidMsg
    call WriteString
    jmp END_PROGRAM

END_CALC:
    ; Ask if user wants to continue after error
    mov edx, OFFSET continueMsg
    call WriteString
    call ReadChar
    mov continue, al
    cmp continue, 'y'
    je CONTINUE_CALC
    cmp continue, 'n'
    je END_PROGRAM

    ; Invalid input handling
    mov edx, OFFSET invalidMsg
    call WriteString

END_PROGRAM:
    exit

main ENDP

END main
