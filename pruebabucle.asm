.data

Vector: .word 45, 32, 45, 88, 100

.text

Main: 	li $t0, 0 # se le asigna al registro $t3 el valor de 0
	la $t1, Vector #guardar la dirección del vector 

Loop:	sll $t2, $t0, 2 #tenemos organizado 4*i
	add $t2, $t1, $t2 # $t1 + $t2 = $t2
	lw $t2, 0($t2) #se carga el dato de la memoria
	slti $at, $t0, 5 # if ($t0 < 5)
	beqz $at, Exit  #se realiza la comparacion if($at != 0)
	addi $a0, $t2, 0 #se pone el valor del vector como argumento
	li $v0,1 #cargo el syscall
	syscall
	addi $t0, $t0, 1 # i = i+1
	j Loop #Se devuelve a la etiqueta Loop
	
	
	

Exit:
   li $v0, 10
   syscall
	
	
	
	
	
	

	
	
