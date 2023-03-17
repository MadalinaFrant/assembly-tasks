; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; TODO: Implement ages
    ;; FREESTYLE STARTS HERE

    mov eax, 0      ; index (eax == i)
    xor ebx, ebx    ; resetare / initializare ebx

while_year:
    mov ebx, [esi + my_date.year] ; present.year
    mov [ecx + eax * 4], ebx ; all_ages[i] = present.year
    mov ebx, [edi + eax * my_date_size + my_date.year] ; dates[i].year
    sub [ecx + eax * 4], ebx ; all_ages[i] = present.year - dates[i].year
    jge while_month ; anul nasterii <= an curent 
    
    mov dword [ecx + eax * 4], 0 ; anul nasterii > an curent
    jmp go_next

while_month:
    xor ebx, ebx ; resetare ebx
    mov bx, [edi + eax * my_date_size + my_date.month] ; dates[i].month
    cmp bx, [esi + my_date.month] ; dates[i].month ? present.month
    je while_day ; luna nasterii = luna curenta
    jg sub_1 ; luna nasterii > luna curenta
    jmp go_next ; luna nasterii < luna curenta

while_day:
    xor ebx, ebx ; resetare ebx
    mov bx, [edi + eax * my_date_size + my_date.day] ; dates[i].day
    cmp bx, [esi + my_date.day] ; dates[i].day ? present.day
    jg sub_1 ; ziua nasterii > ziua curenta
    jmp go_next ; ziua nasterii <= ziua curenta

sub_1:
    cmp dword [ecx + eax * 4], 0 ; daca varsta este 0, nu se mai scade 1 din aceasta
    je go_next
    sub dword [ecx + eax * 4], 1

go_next:
    inc eax ; index creste cu 1
    cmp edx, eax ; se verifica daca s-a terminat parcurgerea
    jne while_year

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY