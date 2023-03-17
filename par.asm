section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	push ebp

	; echivalent mov ebp, esp 
	push esp
	pop ebp

	; ecx = str_length
	push dword [ebp + 8]
	pop ecx

	; edx = str
	push dword [ebp + 12]
	pop edx 

	; ebx = 0 -> index parcurgere sir 
	push 0
	pop ebx 

	; esi = 0 -> numar paranteze stanga
	push 0
	pop esi 

	; edi = 0 -> numar paranteze dreapta
	push 0
	pop edi 

loop_string:
	cmp byte [edx + ebx], 40 ; '('
	je left

	cmp byte [edx + ebx], 41 ; ')'
	je right

left:
	inc esi ; creste numarul parantezelor la stanga
	jmp next_char

right:
	inc edi ; creste numarul parantezelor la dreapta
	jmp next_char

next_char:
	inc ebx ; incrementeaza indexul pentru a trece la urmatorul caracter
	cmp ebx, ecx ; se iese din bucla cand indexul devine egal cu lungimea sirului
	jne loop_string


	cmp esi, edi ; verifica daca numarul parantezelor corespunde
	je correct ; numar egal parenteze stanga si dreapta => secventa corecta
	jmp incorrect ; numar inegal => secventa incorecta

correct:
	push 1
	jmp end

incorrect:
	push 0
	jmp end
	
end:
	; functia returneaza 1 pentru secventa corecta,
	; respectiv 0 pentru incorecta
	pop eax

	; echivalent mov esp, ebp 
	push ebp 
	pop esp 
	
	pop ebp
	
	ret
