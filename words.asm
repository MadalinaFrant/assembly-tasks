global get_words
global compare_func
global sort

section .data
    ; se definesc delimitatorii intr-un sir ce va fi dat ca parametru functiei strtok
    delimiters db " ,.", 10, 0 ; 10 = codul ASCII pentru '\n'

section .text

extern qsort
extern strtok
extern strcmp 
extern strlen

;; int compare_func(const void *p1, const void *p2)
;   functie ce va fi data ca parametru functiei qsort
;   cuvintele vor fi sortate dupa lungime, in caz de egalitate lexicografic
compare_func:
    enter 8, 0 ; aloca spatiu pe stiva pentru 2 variabile locale de 4 octeti

    mov ecx, [ebp + 8]  ; p1
    mov edx, [ebp + 12] ; p2

    pusha ; retine valorile registrelor; acestea vor fi modificate dupa apelul strlen

    ; strlen(p1)
    push dword [ecx]
    call strlen 
    add esp, 4
    mov [ebp - 4], eax ; salveaza local lungimea primului sir

    popa ; se reiau valorile registrelor salvate


    pusha ; retine valorile registrelor; acestea vor fi modificate dupa apelul strlen

    ; strlen(p2)
    push dword [edx] 
    call strlen 
    add esp, 4
    mov [ebp - 8], eax ; salveaza local lungimea celui de-al doilea sir

    popa ; se reiau valorile registrelor salvate

    mov eax, 0 ; in eax se va returna rezultatul functiei de comparare:
    ; 1 pt. p1 > p2, -1 pt. p1 < p2, 0 pt. p1 = p2

    ; salveaza pe stiva cele 2 registre pentru a le putea folosi 
    push esi 
    push edi 

    mov esi, [ebp - 4] ; strlen(p1)
    mov edi, [ebp - 8] ; strlen(p2)

    cmp esi, edi
    je lex ; lungime egala => cuvintele vor fi ordonate lexicografic
    jg greater ; p1 > p2
    jl less    ; p1 < p2

greater:
    inc eax ; functia va returna 1
    jmp end

less:
    dec eax ; functia va returna -1
    jmp end

lex:
    ; strcmp(p1, p2) (rezultatul va fi plasat in registrul eax)
    push dword [edx] ; p2
    push dword [ecx] ; p1
    call strcmp
    add esp, 8

end:
    ; reia de pe stiva valorile registrelor 
    pop edi 
    pop esi 

    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru sortarea cuvintelor 
;  dupa lungime si apoi lexicografic
sort:
    enter 0, 0

    ; qsort(words, number_of_words, size, compare_func)
    push dword compare_func
    push dword [ebp + 16] ; size
    push dword [ebp + 12] ; number_of_words
    push dword [ebp + 8]  ; words
    call qsort
    add esp, 16

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    mov esi, [ebp + 8]  ; s
    mov ebx, [ebp + 12] ; words -> vector de stringuri
    mov ecx, [ebp + 16] ; number_of_words

    mov edi, 0 ; index folosit pentru a parcurge cuvintele din sir

    ; strtok(s, delimiters)
    push delimiters
    push esi 
    call strtok
    add esp, 8

loop_string:
    cmp eax, 0 ; nu mai exista cuvinte in sir (rezultat strtok = NULL)
    je finished_words

    ; words[i] = rezultat strtok (cuvant curent)
    ; words = vector de pointeri => index * 4 (dimensiune pointer)
    mov [ebx + edi * 4], eax

    inc edi ; incrementare index

    ; strtok(NULL, delimiters)
    push delimiters
    push 0 
    call strtok
    add esp, 8

    jmp loop_string

finished_words:
    leave
    ret
