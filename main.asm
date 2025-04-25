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
         db "6. About",13,10
         db "7. Exit.",13,10
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
    msgabout db "Designed & Coded By : AMARA KHALED WALID",13,10,07,07
             db "Supervised by: Ms. MILI Saoussen & ZOUANA SEYF EDDINE$",13,10
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
    je About
    cmp bl, '7'
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
    mov ax, ds
    mov es, ax
    lea dx, Entername        
    mov ah, 9  
    int 21h
    lea dx, newline
    mov ah, 9  
    int 21h
    lea dx, Buffer
    mov ah, 0Ah 
    int 21h
    mov si, dx
    mov cl,byte ptr [si + 1]
    mov ch, 0 
    mov di, dx
    add di, 2
    convert_loop:
        mov al, [di]
        cmp al, 'A'
        jl skip
        cmp al, 'Z'
        jg skip
        add al, 32               
        mov [di], al
    skip:
        inc di
        loop convert_loop
    mov ax, si
    xor cx, cx
    mov cl, [si + 1]
    mov di, bx
    add si, 2
    rep movsb
    mov si, ax
    lea dx, newline
    mov ah, 9  
    int 21h
    lea dx, nameadded
    mov ah, 9 
    int 21h
    lea dx, newline
    mov ah, 9  
    int 21h 
    lea dx, Enterphone
    mov ah, 9  
    int 21h
    lea dx, newline
    mov ah, 9  
    int 21h
    lea dx, Buffer
    mov ah, 0Ah 
    int 21h
    mov ax, si 
    xor cx, cx
    mov cl, [si + 1]
    mov di, bx
    add di, 176
    add si, 2
    rep movsb
    mov si, ax
    lea dx, newline
    mov ah, 9  
    int 21h
    lea dx, phoneadded
    mov ah, 9 
    int 21h
    lea dx, newline
    mov ah, 9  
    int 21h 
    
    lea di, order
    mov si, bx
    mov cl, Taken
    cmp cl, 0
    je empty
    getplace_loop:
        mov ax, si
        mov dx, di
        mov di,[di]
        push cx
        mov cl, [si]
        mov ch, [di]
        cmp cl, ch
        pop cx
        jl insert
        mov si, ax
        mov di, dx
        add di, 2
        dec cl
        cmp cl, 0
        jle insertend
        jmp getplace_loop
    insert:
        mov si, ax
        mov di, dx
        inc Taken
    again:    
        mov ax, [di]
        mov [di], si
        mov si, ax
        add di, 2
        cmp di, 384
        jl again
        jmp endadd
    empty:
        mov order ,bx
        inc Taken    
        jmp endadd
    insertend:
        mov [di],si
        inc Taken
        jmp endadd     
    endadd:
        lea dx, pkey
        mov ah, 09h
        int 21h
    
        mov ah, 01h
        int 21h     
            
       
    jmp dispmenu
viewcontacts:
    cmp Taken, 0
    jle emptyview
    lea si, order
    xor cx, cx
    mov cl, Taken
    order_loop:
        mov di, [si]
        lea dx, contactname
        mov ah, 09h
        int 21h
        lea dx, newline
        mov ah, 9  
        int 21h 
        lea dx, Names[di]
        mov ah, 09h
        int 21h            
        lea dx, newline
        mov ah, 9  
        int 21h
        lea dx, contactnumber   
        mov ah, 09h
        int 21h
        lea dx, newline
        mov ah, 9  
        int 21h
        lea dx, Contacts[di]
        mov ah, 09h
        int 21h
        lea dx, newline
        mov ah, 9  
        int 21h
        lea dx, seperator
        mov ah, 09h
        int 21h
        add si, 2
        lea dx, newline
        mov ah, 9  
        int 21h
        loop order_loop
        jmp viewend
    emptyview:
        lea dx, emptyviewmsg
        mov ah, 09h
        int 21h
    viewend:
    lea dx, pkey
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    jmp dispmenu
    
    
    
    
Search:
    lea dx, requestname
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 9  
    int 21h
    lea dx, Buffer
    mov ah, 0Ah 
    int 21h 
    lea si, Buffer
    add si, 2
    mov dx, si
    lea bx, order
    xor cx, cx    
    mov cl, Taken
    Looking_loop:
        mov si, dx       
        mov di, [bx]
        push cx
        mov cl, [Buffer + 1]
        mov ch, 0
        repe cmpsb
        pop cx
        je found
        add bx, 2
        loop Looking_loop
        jmp notfound
    found:
        mov di,[bx]
        lea dx, contactfound
        mov ah, 09h
        int 21h
        lea dx, newline
        mov ah, 9  
        int 21h
        lea dx, contactname
        mov ah, 09h
        int 21h
        lea dx, newline
        mov ah, 9  
        int 21h 
        lea dx, Names[di]
        mov ah, 09h
        int 21h            
        lea dx, newline
        mov ah, 9  
        int 21h
        lea dx, contactnumber
        mov ah, 09h
        int 21h
        lea dx, newline
        mov ah, 9  
        int 21h
        lea dx, Contacts[di]
        mov ah, 09h
        int 21h
        lea dx, newline
        mov ah, 9  
        int 21h
        jmp done_search
    notfound:
        lea dx, contactnotfound
        mov ah, 09h
        int 21h
    done_search:
    lea dx, pkey
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    jmp dispmenu
    
    
    
Modify:
    lea dx, requestname
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 9  
    int 21h
    lea dx, Buffer
    mov ah, 0Ah 
    int 21h 
    lea si, Buffer
    add si, 2
    mov dx, si
    lea bx, order
    xor cx, cx    
    mov cl, Taken
    Looking_loop_modify:
        mov si, dx       
        mov di, [bx]
        push cx
        mov cl, [Buffer + 1] 
        mov ch, 0
        repe cmpsb
        pop cx
        je found_modify
        add bx, 2
        loop Looking_loop_modify
        jmp notfound_modify
    found_modify:
            
        mov di,[bx]
        lea dx, contactfound
        mov ah, 09h
        int 21h
        lea dx, newline
        mov ah, 9  
        int 21h
        
        ; Reset the memory slot with $
        push di
        lea si, Contacts[di]
        mov cx, 11
        reset_slot:
            mov byte ptr [si], '$'
            inc si
            loop reset_slot
            
        pop di
        lea dx, newphonenumber
        mov ah, 09h
        int 21h
        lea dx, newline
        mov ah, 9
        int 21h
        
        lea dx, Buffer
        mov ah, 0Ah 
        int 21h
        
        mov cl, [Buffer + 1]
        mov ch, 0
        lea si, Buffer
        add si, 2
        lea di, Contacts[di]
        rep movsb
        
        lea dx, newline
        mov ah, 9
        int 21h
        lea dx, phoneadded             
        mov ah, 09h  
        int 21h
        jmp done_search_modify
    notfound_modify:
        lea dx, contactnotfound
        mov ah, 09h
        int 21h
    done_search_modify:
    lea dx, pkey
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    jmp dispmenu
    
    
    
    
Delete:
    lea dx, requestname
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 9  
    int 21h
    lea dx, Buffer
    mov ah, 0Ah 
    int 21h 
    lea si, Buffer
    add si, 2
    mov dx, si
    lea bx, order
    xor cx, cx    
    mov cl, Taken
    Looking_loop_delete:
        mov si, dx       
        mov di, [bx]
        push cx
        mov cl, [Buffer + 1] 
        mov ch, 0
        repe cmpsb
        pop cx
        je found_delete
        add bx, 2
        loop Looking_loop_delete
        jmp notfound_delete
    found_delete:
        mov di,[bx]
        push di
        lea si, Names[di]
        mov cx, 11
        reset_names:
            mov byte ptr [si], '$'
            inc si
            loop reset_names
          
        pop di
        push di
        lea si, Contacts[di]
        mov cx, 11           
        reset_contacts:
            mov byte ptr [si], '$'
            inc si
            loop reset_contacts

        pop di
        push bx
        again_delete:
            mov si, [bx + 2]
            mov [bx], si
            add bx, 2
            cmp bx, offset order + 32  ; 16 entries * 2 bytes each
            jge done_delete
            jmp again_delete
        done_delete:
        dec Taken            
        jmp done_search_delete    
        
    notfound_delete:
        lea dx, contactnotfound
        mov ah, 09h
        int 21h
    done_search_delete:
    lea dx, pkey
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    jmp dispmenu
About:
    mov ah, 06h    
    mov al, 0       
    mov bh, 07h     
    mov cx, 0000h   
    mov dx, 184Fh   
    int 10h         
    
    lea dx, msgabout
    mov ah, 09h
    int 21h
        
    lea dx, pkey
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    jmp dispmenu
    
    
Exit:
    lea dx, Entername
    jmp end 
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
