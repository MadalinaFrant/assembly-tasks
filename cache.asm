;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS


section .text
    global load

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; TODO: Implment load
    ;; FREESTYLE STARTS HERE
    
    push eax ; se retine eax (pentru a putea folosi registrul)

    mov esi, edx
    shr edx, OFFSET_BITS ; tag
    shl esi, TAG_BITS ; <offset>000...
    shr esi, TAG_BITS ; ...000<offset>
    push esi ; se retine offset-ul (pentru a putea folosi registrul esi)

    mov esi, 0 ; index cu ajutorul caruia se va itera prin tags

search_tags: 
    cmp [ebx + esi], edx ; verifica daca tagul exista in tags
    je write_reg ; daca a fost gasit 
    inc esi ; indexul creste cu 1
    cmp esi, CACHE_LINES ; verificare terminare parcurgere vector (tags)
    jne search_tags

    ; daca tagul nu a fost gasit in tags:
    mov [ebx + edi], edx ; scrie tag in tags la linia to_replace
    shl edx, OFFSET_BITS ; adauga "000" la sfarsitul lui tag
    mov ebx, 0 ; index cu ajutorul caruia se va itera prin linia cache[to_replace]

    push edx ; se retine edx deoarece mul modifica valoarea acestuia
    mov eax, CACHE_LINE_SIZE
    mul edi ; eax = CACHE_LINE_SIZE * to_replace
    pop edx ; reia valoarea din edx 

write_cache:
    push eax ; se retine rezultatul inmultirii CACHE_LINE_SIZE * to_replace
    add eax, ebx ; indexul corespunzator scrierii pe linia din cache[to_replace]
    push ebx ; retine valoarea din ebx (indexul)
    mov ebx, [edx] ; valoarea octetului de la adresa salvata in edx
    mov [ecx + eax], ebx ; cache[to_replace][k] = octetul de la adresa calculata
    pop eax ; reia valoarea din eax 
    pop ebx ; reia valoarea din ebx 
    inc edx ; incrementeaza adresa de la care se va lua urmatorul octet
    inc ebx ; creste indexul cu 1
    cmp ebx, CACHE_LINE_SIZE ; verificare terminare parcurgere linie
    jne write_cache
    
    ; in cazul CACHE MISS, in registru va fi scris octetul cache[to_replace][offset]
    mov esi, edi ; => in acest caz i va fi to_replace

write_reg:
    mov eax, CACHE_LINE_SIZE
    mul esi 
    pop esi ; se reia in esi valoarea offset
    add eax, esi ; indexul = CACHE_LINE_SIZE * i + offset
    mov ebx, eax
    pop eax ; se reia adresa unde va trebui scris rezultatul
    mov edx, [ecx + ebx] ; cache[i][offset]
    mov [eax], edx ; scrie in registru valoarea obtinuta

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY