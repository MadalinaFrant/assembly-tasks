section .data
    extern len_cheie, len_haystack

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ; key
    mov esi, [ebp + 12]  ; haystack
    mov ebx, [ebp + 16]  ; ciphertext
    ;; DO NOT MODIFY

    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE
    
    mov ecx, 0 ; index key (i)
    mov eax, 0 ; index ciphertext (j)

while_key:
    ; k = indexul cu ajutorul caruia se va trece printr-o coloana
    mov edx, [edi + ecx * 4] ; k = key[i] (initial)
    push ecx ; salveaza pe stiva valoarea ecx reprezentand index key

while_column:
    ; este folosit cl (8 biti) deoarece se muta un char (un octet)
    mov cl, [esi + edx] ; haystack[k]
    mov [ebx + eax], cl ; ciphertext[j]
    add edx, [len_cheie] ; k += len_cheie (creste cu lungimea cheii)
    inc eax ; creste indexul pt. ciphertext cu 1
    ; se verifica daca s-a iesit din limitele sirului
    cmp edx, [len_haystack]
    jl while_column

    pop ecx ; reia de pe stiva valoarea ecx reprezentand index key
    inc ecx ; creste indexul pt. key cu 1
    ; se verifica daca s-a terminat parcurgerea vectorului de ordine
    cmp ecx, [len_cheie]
    jne while_key

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY