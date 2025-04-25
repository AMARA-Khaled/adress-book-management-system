; multi-segment executable file template.
data segment 
    Names dB 176 dup("$")
    Contacts db 176 dup ("$")
    order dw 16 dup(?)
    Taken db 0
    Buffer db 11,12 dup(?)
    menu db 13,10,03,32,"Choose an option:",32,03,13,10
         db "1. Add a contact.",13,10
         db "2. View all contacts.",13,10
         db "3. Search a contact.",13,10
         db "4. Modify a contact.",13,10
         db "5. Delete a Contact.",13,10
         db "6. Exit.",13,10
         db "Enter your choice (1-6): $"
    newline db 13,10,"$"
    Entername db "Enter the name (up to 10 characters):$"
    nameadded db "Name added successfully.$"  
    Enterphone db "Enter the phone number (up to 10 characters):$"
    Phoneadded db "Phone number added successfully.$"
    contactname db "Name: $"
    contactnumber db "Phone Number: $"
    seperator db "===============$"
    requestname db "Please type in the name of the contact you're looking for: $"
    emptyviewmsg db "No Contacts saved!$"
    contactnotfound db "No Contact with the provided Name$"
    contactfound db "Contact found!$"
    newphonenumber db "Type in the new phone number: $"
    pkey db 13,10,"Press any key...$"
    msg_invalid db "invalide choice. $"
    fullspace db "No space, please delete some contacts before adding a new one. $"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    dispmenu:; show menu
    lea dx, menu
    mov ah, 09h
    int 21h

    ; read one char from keyboard
    mov ah, 01h
    int 21h
    mov bl, al
    lea dx, newline
    mov ah, 9  
    int 21h

    ; store input in BL
    cmp bl, '1'
    je addcontact
    cmp bl, '2'
    je viewcontacts
    cmp bl, '3'
    je Search
    cmp bl, '4'
    je Modify
    cmp bl, '5'
    je Delete
    cmp bl, '6'
    je Exit

    ; if none matched, show invalid
    lea dx, msg_invalid
    mov ah, 9  
    int 21h
    jmp dispmenu

addcontact:
    lea bx, Names
    mov ax,1
    while:cmp [bx], "$"  
    je adding
    add bx, 11
    inc ax
    cmp ax, 17
    jge full
    jmp while
full:
    lea dx, fullspace
    mov ah, 9  
    int 21h
    jmp end
adding: 
    lea dx, Entername
    jmp dispmenu
Search:
    lea dx, Entername
    jmp dispmenu
Modify:
    lea dx, Entername
    jmp dispmenu
Delete:
    lea dx, Entername
    jmp dispmenu
Exit:
    lea dx, Entername
    jmp end
jmp dispmenu 
end:  
            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
