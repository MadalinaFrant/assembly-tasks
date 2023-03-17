section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	push ebp

	; echivalent mov ebp, esp 
	push esp
	pop ebp

	; ecx = a
	push dword [ebp + 8]
	pop ecx

	; edx = b
	push dword [ebp + 12]
	pop edx 

cmmdc:
	cmp ecx, edx 
	je gen_cmmmc ; cele 2 numere devin egale => s-a gasit cmmdc

	jg sub_from_a ; a > b
	jl sub_from_b ; a < b

sub_from_a:
	sub ecx, edx ; a = a - b
	jmp cmmdc

sub_from_b:
	sub edx, ecx ; b = b - a
	jmp cmmdc

	; ecx = edx = cmmdc(a, b)

gen_cmmmc:
	; eax = a
	push dword [ebp + 8]
	pop eax

	; ebx = b
	push dword [ebp + 12]
	pop ebx

	mul ebx ; a * b
	div ecx ; (a * b) / cmmdc => eax = cmmmc(a, b)
	
	; echivalent mov esp, ebp 
	push ebp 
	pop esp 
	
	pop ebp

	ret
