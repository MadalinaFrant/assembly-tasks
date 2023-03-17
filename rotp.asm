section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; TODO: Implment rotp
    ;; FREESTYLE STARTS HERE
    
    mov eax, 0      ; index (eax == i)
    xor ebx, ebx    ; resetare / initializare ebx

while:
    ; scade len cu 1 (caracterele din key se iau de la sfarsit spre inceput)
    dec ecx
    mov bl, [esi + eax] ; plaintext[i]
    xor bl, [edi + ecx] ; plaintext[i] ^ key[len - i - 1]
    mov [edx + eax], bl ; ciphertext[i] = plaintext[i] ^ key[len - i - 1]
    inc eax             ; index creste cu 1
    cmp ecx, 0          ; se verifica daca s-a terminat parcurgerea sirurilor
    jne while

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY