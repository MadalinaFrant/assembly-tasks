section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

struc node_struct
    .val: resd 1
    .next: resd 1
endstruc

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0

	mov eax, [ebp + 12] ; node
	mov ecx, [ebp + 8] ; n

	mov esi, 0 ; index cu ajutorul caruia se va parcurge vectorul de structuri

loop_list:
	mov ebx, dword [eax + esi * node_struct_size + node_struct.val]

	cmp ebx, ecx 
	; daca elementul curent este n, adica cel mai mare => va fi ultimul nod din lista =>
	; => campul next ramane NULL
	je next_iteration

	; se cauta urmatorul element din lista, adica succesorul (consecutivul) elementului curent
	inc ebx

	; index cu ajutorul caruia se parcurge vectorul de structuri pentru a gasi 
	; succesorul elementului curent
	mov edi, 0

find_next:
	cmp ebx, [eax + edi * node_struct_size + node_struct.val]
	je update_next ; s-a gasit succesorul 

	inc edi ; se trece la urmatoarea iteratie daca nu s-a ajuns la elementul cautat
	jmp find_next

update_next:
	; se retine eax deoarece se va realiza operatia mul al carui rezultat este salvat in eax
	push eax

	mov eax, node_struct_size
	mul edi 
	mov edx, eax ; edi * node_struct_size

	pop eax ; se reia eax (adresa de inceput a listei)

	; in edx se retine adresa nodului ce va fi atribuita campului next al nodului curent
	add edx, eax ; edx = eax + edi * node_struct_size
	; se actualizeaza campul next al nodului curent
	mov dword [eax + esi * node_struct_size + node_struct.next], edx

	; se trece la urmatoarea iteratie
next_iteration:
	inc esi 
	cmp esi, ecx 
	jne loop_list
    
	; se mai parcurge o data vectorul in vederea actualizarii adresei de inceput a listei

	mov esi, 0 ; index cu ajutorul caruia se va parcurge vectorul de structuri

find_head:
	mov ebx, dword [eax + esi * node_struct_size + node_struct.val]
	; se cauta nodul 1 care va reprezenta inceputul listei
	cmp ebx, 1
	je update_head ; nodul 1 gasit

	inc esi ; se trece la urmatoarea iteratie daca nu a fost gasit inca 1
	jmp find_head

update_head:
	; se retine eax deoarece se va realiza operatia mul al carui rezultat este salvat in eax
	push eax 

	mov eax, node_struct_size
	mul esi 
	mov edx, eax ; esi * node_struct_size

	pop eax ; se reia eax (adresa de inceput a listei)

	; in edx se retine adresa nodului 1 ce va reprezenta adresa de inceput a listei
	add edx, eax ; edx = eax + esi * node_struct_size
	; se actualizeaza adresa de inceput a listei
	mov eax, edx

	leave
	ret
