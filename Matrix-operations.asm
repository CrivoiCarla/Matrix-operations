.data
   linie: .long 0
   coloana: .long 0
   matrice: .space 401
   total: .space 4
   chDelim: .asciz " "
   chsp: .asciz "\n"
   c: .asciz ""
   formatPrintf: .asciz "%d "
   str: .space 301
   rez: .space 4
   indexl : .long 0
   indexc: .long 0
   minus: .long -1

.text

.global main


main:
    movl $matrice,%esi

    pushl $str
    call gets
    popl %ebx

    # numele matricei
    pushl $chDelim
    pushl $str
    call strtok 
    popl %ebx
    popl %ebx

    xor %eax,%eax

    #linie 
    pushl $chDelim
    pushl $0
    call strtok
    popl %ebx
    popl %ebx 

    movl %eax, rez
    pushl rez
    call atoi
    popl %ebx

    movl %eax,linie

    #coloana 
    pushl $chDelim
    pushl $0
    call strtok
    popl %ebx
    popl %ebx 

    movl %eax, rez
    pushl rez
    call atoi
    popl %ebx

    movl %eax, coloana
    mull linie
    decl %eax
    movl %eax,total

    xor %ecx,%ecx
    pushl %ecx
    
  
et_for:

    pushl $chDelim
    pushl $0
    call strtok
    popl %ebx
    popl %ebx 


    cmp $0, %eax
    je et_afisarematrice

    movl %eax, rez
    pushl rez
    call atoi
    popl %ebx

    cmp $0, %eax
    je et_operatie

    popl %ecx
    movl total,%ebx

    cmp %ebx, %ecx
    jbe et_matrice

    push %eax
    jmp et_for
et_matrice:

    movl %eax, (%esi,%ecx,4)
    incl %ecx
    pushl %ecx
    jmp et_for

et_operatie:

    movl rez,%edi
    xor %ecx,%ecx

    movb (%edi,%ecx,1),%al
    xor %ecx,%ecx
    
    xor %ebx,%ebx
    cmp $114, %al 
        je et_rot
    
    popl %ebx
    cmp $97, %al 
    je et_add

    cmp $108, %al 
    je et_let

    cmp $115, %al 
    je et_sub

    cmp $109, %al 
    je et_mul

    cmp $100, %al 
    je et_div

et_afis:

    push linie
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx
   
    push coloana
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx
    jmp et_afisarematrice
et_add:

    movl total,%eax

        cmp %eax, %ecx
        jbe et_madd

    xor %ecx,%ecx
    jmp et_afis
et_madd:
    movl (%esi,%ecx,4),%edx
    add %ebx,%edx
    movl %edx,(%esi,%ecx,4)
    incl %ecx
    jmp et_add
et_let:
     pushl $chDelim
        pushl $0
        call strtok
        popl %ebx
        popl %ebx
        
        cmp $0,%eax
        je et_afis
        
        movl %eax, rez
    	pushl rez
    	call atoi
   	 popl %ebx
    
     	 cmp $0,%eax
     	 jne et_push
     	 
     	movl rez,%edi
     	pushl %ecx
     	
	movl $1,%ecx
    	movb (%edi,%ecx,1),%al
    	
    	popl %ecx
    	
    	cmp $0,%eax
    	jne et_operatie

      
    	jmp et_for
	
et_push:
	pushl %eax
	jmp et_for

et_sub:
    movl total,%eax

        cmp %eax, %ecx
        jbe et_msub

    xor %ecx,%ecx
    jmp et_afis
et_msub:
    movl (%esi,%ecx,4),%edx
    sub %ebx,%edx
    movl %edx,(%esi,%ecx,4)
    incl %ecx
    jmp et_sub

et_mul:
    movl total,%eax

        cmp %eax, %ecx
        jbe et_mmul

    xor %ecx,%ecx
    jmp et_afis
et_mmul:
    movl (%esi,%ecx,4),%edx
    pushl %eax
    movl %edx,%eax
    mul %ebx
    movl %eax,%edx
    popl %eax
    movl %edx,(%esi,%ecx,4)
    incl %ecx
    jmp et_mul
et_div:
    movl total,%eax

        cmp %eax, %ecx
        jbe et_mdiv

    xor %ecx,%ecx
    jmp et_afis
    
et_mdiv:
    movl (%esi,%ecx,4),%edx
    pushl %eax
    movl %edx,%eax
    xor %edx,%edx
    cdq 
    idiv %ebx
    movl %eax,%edx
    popl %eax
    movl %edx,(%esi,%ecx,4)
    incl %ecx
    jmp et_div
    
et_rot:
    push coloana
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx
   
    push linie
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

    movl $0, indexc
    
    for_linie:
    
    	 movl indexc, %ecx
    	 #cmp %ecx , minus
    	 cmp %ecx , coloana
    	 je et_exit
    	 
    	 movl linie,%eax
      	 movl %eax, indexl
   	 decl indexl
   for_coloana:
   	 movl indexl, %ecx
    	 #cmp %ecx , coloana
    	 cmp %ecx , minus
    	 je for_linie1   
    	 
    	 movl indexl, %eax
    	 movl $0,%edx
    	 mull coloana
    	 addl indexc, %eax
    	 
    	 movl (%esi,%eax,4), %ecx
    	 pushl %ecx
    	 pushl $formatPrintf
    	 call printf
    	 popl %ebx
    	 popl %ebx
    	 
    	 #incl indexc
    	 decl indexl 
    	 jmp for_coloana
    	 
    for_linie1:
    	#decl indexl
    	incl indexc
    	jmp for_linie

	
et_afisarematrice:
    movl total,%ebx
    incl %ebx
    cmp %ebx, %ecx
    je et_exit
    movl (%esi,%ecx,4),%eax
      push %ecx
      pushl %eax
et_afisare:

    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

    popl %ecx
    incl %ecx

    jmp et_afisarematrice


et_exit:
    #pushl $0
    pushl $chsp
    call printf
    popl %ebx
    popl %ebx

    movl $1,%eax
    xorl %ebx,%ebx
    int $0x80
