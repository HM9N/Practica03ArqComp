.data

Vector: .word 45, 32, 45, 88, 100

.text

Main: 
	addi $t3, $zero, 0 # se le asigna al registro $t3 el valor de 1
	la $t0, Vector #guardar la dirección del vector 

Loop:	sll $t1, $t3, 2 #tenemos organizado 4*i
	add $t1, $t0, $t1 # $t1 + $t0 = $t1
	lw $t2, 0($t1) #se carga el dato de la memoria
	slti $at, $t3, 5 # if ($t3 < 5)
	beqz $at, Exit  #se realiza la comparacion if($at != 0)
	addi $a0, $t2, 0 #se pone el valor del vector como argumento
	li $v0,1 #cargo el syscall
	syscall
	addi $t3, $t3, 1 # i = i+1
	j Loop #Se devuelve a la etiqueta Loop
	
	
	

Exit:
   addi $a0, $a0, 1
   li $v0, 1
   syscall
	
	
	
	
	
	

	
	
