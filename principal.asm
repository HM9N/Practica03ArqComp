# Arquitectura de Computadores y Laboratorio
# 2020-01
# Laboratorio 03
# Jhon Vásquez y Brandon Duque
# Universidad de Antioquia 
# Medellín - Colombia

.data 
archivoEntrada: .asciiz "archivo.txt"
archivoSalida: .asciiz "archivoSalida.txt"
sentence: .byte 0x0A, 0x0D, 0x0A, 0x0D
mensaje01: .asciiz "Ingresa la cantidad de cadenas de caracteres a identificar"
mensaje02: .asciiz "Ingresa la cadena de caracteres"
mensaje03: .asciiz "El programa ha finalizado, puedes ir a la carpeta donde está el ejecutable de mars para verificar el archivo"
nueva_linea: .asciiz "\n"
numerosAscii: .byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39 # Códigos ASCII para los números del 0 al 9
espacio: .ascii "                             " # Espacio para organizar la impresión de datos
.align 2
textoEntrada: .space 20000 #Buffer para almacenar el texto que se lee en el archivo

.align 2
cadenaAbuscar: .space 200 # Cadena que ingresa el usuario para buscar
#--------------------------------------------------------------------------------------------------#
# ------------------------- Inicio de la ejecucación del programa ---------------------------------#
.text 

Main: 		# Abrir (para lectura) un archivo
		li $v0, 13		# System call para abrir un archivo
		la $a0, archivoEntrada	# dirección del archivo a abrir
		li $a1, 0		# Abrir para lectura (flag = 0)
		li $a2, 0		# El modo es ignorado
		syscall			# Abrir el archivo (El descriptor del archivo es retornado en $v0)
		move $s0, $v0		# hacer una copia del descriptor del archivo
	
		# Crear un archivo y abrirlo para escritura
		li $v0, 13		# System call para abrir un archivo
		la $a0, archivoSalida	# dirección del archivo a abrir
		li $a1, 9		# Abrir para escritura y anexación (flag = 9)
		li $a2, 0		# El modo es ignorado
		syscall			# Abrir el archivo (El descriptor del archivo es retornado en $v0)
		move $s1, $v0		# hacer una copia del descriptor del archivo
	
		# Leer el archivo de entrada
		li $v0, 14		# System call para leer un archivo
		move $a0, $s0		# descriptor del archivo
		la $a1, textoEntrada	# Dirección de input buffer
		li $a2, 20000		# número máximo de caracteres a leer
		syscall			# Ejecutar el Syscall
		move $s2, $v0		# Se hace una copia de la cantidad de caracteres
	
		# Pedir al usuario la cantidad de cadena de caracteres a identificar
		li $v0, 4 		# syscall para imprimir un mensaje en consola
		la $a0, mensaje01 	# mensaje a imprimir
		syscall
	
		# Se obtiene el número de cadenas de caracteres a identificar ingresado por el usuario
		li $v0, 5 		# syscall para leer un entero ingresado en la consola
		syscall
	
		# Se guarda el número de cadenas de caracteres a identificar ingresado por el usuario 
		move $t3,$v0 		# Hacer una copia del entero ingresado por el usuario en el registro $t3
	
		li $s3, 0 		# se le asigna al registro $s3 el valor de 0 (funcionará como un contador i para el primer ciclo)

# - - - - - - - - - - - - - - - - - - - - - - - - -- - - - - - - - - - -- - - - - - - - - -- - - - - - -- - - #
      	      	
Loop01:		# Se empieza el primer ciclo
		slt $at, $s3, $t3 	# if ($s3 < $t3) returns 1
		beqz $at, Exit  	#se realiza la comparacion if($at == 0)
		
		# Se inicializan las variables a usar durante cada recocimiento de la respectiva cadena de carácteres
		li $t4, 0
		li $s7, 0
		li $s4, 0    		# $s4 funcionará como un contador i para el siguiente ciclo (se le asigna el valor de 0)
		
		# Se le pide al usuario ingresar el texto a identificar
		li $v0, 4		 # mostrar mensaje a usuario
		la $a0, mensaje02 
		syscall
		li $v0, 8		 # Se guarda el texto ingresado por el usuario
		la $a0, cadenaAbuscar
		li $a1, 200
		syscall
		
		# Se calcula la longitud del texto ingresado por el usuario #
		la $a0, cadenaAbuscar
		jal Longitud   		# Llamada al procedimiento Longitud
	 	addi $t4, $v0, 0
	 	addi $t4, $t4, -1
	 	
		# Se ejecuta el while que garantiza que se va a procesar la cantidad de cadenas de caracteres deseadas por el usuario 
		# Este ciclo está dentro del primir ciclo (es un ciclo anidado)
Loop02:		la $s5, textoEntrada 		# guardar la dirección del texto de entrada
		add $s5, $s5, $s4 		# se le suma j a la dirección de memoria del texto
		lb $a3, 0($s5) 			# se usa la instrucción load byte para cargar el byte desde la memoria
		slt $at, $s4, $s2 		# if ($s4 < $s2) returns 1
		beqz $at, EndLoop01  		# Se realiza la comparacion if($at == 0)
		la $a0, cadenaAbuscar		# Se carga la dirección de memoria del texto ingresado por el usuario
		lb $t0, 0($a0)			# Se carga el byte correspondiente
		bne $a3, $t0, SumarContador 	# if(a3 != 0) {continue} else {vaya a SumarContador}
		addi $a1, $t4, 0  		# Se prepara $a1 como argumento para la función CompararCaracteres (tiene la longitud de cadenaAbuscar)
	 	la $a0, cadenaAbuscar		# Se carga la dirección de memoria de cadenaAbuscar (para enviarla como argumento a)
		addi $a3, $s4, 0		# Se pasa como argumento la posición del caracter en el archivo que concuerda con el primer carácter del texto ingresado por el usuario
		jal CompararCaracteres          # Se ejecuta el procedimiento de CompararCaracteres
		addi $a0, $v0, 0		# Devuelve el valor booleano (1 si encontró la palabra)
		beqz $a0, SumarContador		# Sí $a0 = 0 vaya a SumarContador
		add $s7, $s7, $v0		# Se acumula la cantidad de veces que aparece la cadena de carácteres en el texto
		j SumarContador
		
SumarContador:	addi $s4, $s4, 1 # j = j+1
		j Loop02 #Se devuelve a la etiqueta Loop02
	
EndLoop01: 	add $a0,$zero, $s7     # Se preparan los argumentos para el procedimiento "Imprimir"
		jal Imprimir	       # Se ejecuta el procemidiento "Imprimir"
		addi $s3, $s3, 1 # i = i+1, se seguira con la siguiente cadena de caracteres 
	   	j Loop01 
	
Exit: 		li   $v0, 16       # system call for close file
		move $a0, $s0      # file descriptor to close
		syscall            # close file
		li   $v0, 16       # system call for close file
		move $a0, $s1      # file descriptor to close
		syscall            # close file
		li $v0, 4 	   #SYSCALL para imprimir un mensaje en consola
      		la $a0, mensaje03  # mensaje a imprimir
      		syscall
      		li $v0, 10 #SYSCALL para finalizar la ejecución del programa
      		syscall
	
		##########################################################################
		# Procedimiento CompararCaracteres
		# Utilidad: Compara desde la posición del caracteres encontrado en el texto que 
		#	    que concuerda con el primer caracter de la cadena ingresada por el usuario
		# Entradas: $a0 Apuntador a la cadena de texto ingresada por el usuario
		# $a1 Longitud de la cadena de texto ingresada por el usuario
		# Salida: si existe la cadena (booleano)
	
CompararCaracteres: 	li $v0, 0
			li $t0, 0 # Contador del ciclo
			li $t2, 0 # Contador de ocurrencia seguidas de caracteres
LoopCC:       	 	la $s6, textoEntrada
			add $s6, $s6, $a3 # Nos situamos en la posición del caracter en el texto
			
			# Se reakuza el para ver si se termina la ejecución del loop y se cargan los bytes para hacer la comparación
			slt $at, $t0, $a1 # if ($t0 < $a1) returns 1
			beqz $at, EndCC  #se realiza la comparacion if($at == 0)
			lb $t1, 0($s6) # se carga el caracter del fichero leído
			lb $t5, 0($a0) #se carga el caracter de el archivo de entrada
		
			# Se incrementa en uno el valor de las variables
			addi $a3, $a3, 1
			addi $a0, $a0, 1
			addi $t0, $t0, 1
			bne $t1, $t5, NoCount # Si no son iguales los bytes, no incrementaen uno en el registro $t2
			addi $t2, $t2, 1
		
			j LoopCC
NoCount:        	j LoopCC
		 	
EndCC:          	beq $t2, $a1, asignarUno # Si la cantidad de bytes que concuerda es igual a la longitud de la cadena ingresada por el usuario, se devuelve uno
			addi $v0, $zero, 0
			jr $ra
asignarUno:     	addi $v0, $zero, 1
			jr $ra
	######### FIN PROCEDIMIENTO CompararCaracteres ##############################
	
	##########################################################################
	# Procedimiento: Longitud
	# Utilidad: Encontrar la longitud de un string 
	# Entrada: Dirección de la cadena ingresada por el usuario en el registro $a0
	# Salida: longitud del String  en el registro $v0
	
Longitud:     addi $v0, $zero, 0 # $v0 nos va a servir como contador para el ciclo

LoopLongitud: lb   $t0,0($a0)      # Se recupera un caracter
    	      beqz $t0,FinLongitud # Se hace la comparación si $t0 != 0
    	      addi $a0,$a0,1       # Se le suma 1 a la base del vector del texto 
    	      addi $v0,$v0,1       # Se le suma uno a $v0 
              j  LoopLongitud
         
FinLongitud:  jr $ra 

		######### FIN PROCEDIMIENTO LONGITUD ##############################

	#####################################################################
	# Procedimiento: Imprimir
	# Utilidad: Imprimir la cadena de caracteres a identificar y su número de ocurrencias en el texto
	# Entrada: Dirección de la cadena ingresada por el usuario en el registro $a0
	# Salida: longitud del String  en el registro $v0
	
Imprimir:	addi $t1, $a0, 0        #Numero a imprimir
		add $t9, $zero, $ra     # Se guarda la dirección de retorno de método imprimir para que no se pierda con el siguiente llamado
		jal LongitudEntero	# Se ejecuta el método LongitudEntero
		# Se prepara la pila para guardar tanto la dirección de retorno del método imprimir como de los números a imprimir
		mul $v0, $v0, -1
		mul $v0, $v0, 4
		addi $t2, $v0, -4
		add $sp, $sp, $t2
		sw $t9, 0($sp)		# Se guarda la dirección de retorno del método imprimir en la primera posición de la pila
		addi $s6, $zero, 0      # Auxiliar para llevar la cuenta de los elementos guardados en la pila
		la $s4, 0($sp)		# $s4 es una variable auxiliar que nos servirá para guardar y recuperar los números de la pila
		addi $s4, $s4, 4
		
LoopPila:	beqz $t1, ImprimirTexto
		addi $s6, $s6, 1	# Se va a sumar cada que se separe un digito
		addi $a0, $t1,0		# Se pasa como argumento al método SepararDigitos el número a procesar
		jal SepararDigitos	
		# Manipulación de la pila
		add $t5, $zero, $v1
		move $t7, $v0
		sw $t5, 0($s4)
		addi $s4, $s4, 4
		add $t1, $zero, $t7
		j LoopPila
		
ImprimirTexto:  li $v0, 15		# System call for write to a file
		move $a0, $s1		# Restore file descriptor (open for writing)
		la $a1, cadenaAbuscar	# Address of buffer from which to write
		addi $a2, $t4, 0	# Number of characters to write
		syscall
	
		li $v0, 15		# System call for write to a file
		move $a0, $s1		# Restore file descriptor (open for writing)
		la $a1, espacio		# Address of buffer from which to write
		addi $a2, $zero, 1	# Number of characters to write
		syscall
		
		# Se prepara la dirección en la pila desde la cual se van a recuperar los números
		addi $t2, $s4, 0
		addi $s4, $s4, -4
				
LoopImp:	la $s5, numerosAscii	# Se apunta a la codificación en ASCII de los números
		#addi $t0, $zero, 1
		beqz $s6, FinalImprimir	
		lw $s0, 0($s4) 	         # Se recupera el número de la pila
		add $s5, $s5, $s0	# Se selecciona la codificación ASCII respectiva 
		li $v0, 15		# System call for write to a file
		move $a0, $s1		# Restore file descriptor (open for writing)
		la $a1, 0($s5)		# Address of buffer from which to write
		addi $a2, $zero, 1	# Number of characters to write
		syscall
		addi $s6, $s6, -1
		addi $s4, $s4, -4
		j LoopImp
FinalImprimir: 	lw $ra, 0($sp) 		# Hacer pop a la pila para recuperar el valor de retorno
		add $sp, $zero, $t2	# Se restaura la dirección inicial de la pila
		li $v0, 15		# System call for write to a file
		move $a0, $s1		# Restore file descriptor (open for writing)
		la $a1, sentence	# Address of buffer from which to write
		li $a2, 4		# Number of characters to write
		syscall
		jr $ra

			######### FIN PROCEDIMIENTO Imprimir ##############################

	#####################################################################
	# Procedimiento: SepararDigitos
	# Utilidad: Separar un número en sus unidades, decenas, centenas, etc
	# Entrada: Dividendo en el registro $a0
	# Salida: Cociente y resto en los registros $v0 y $v1, respectivamente.

SepararDigitos: add $t0, $zero, $a0
		addi $t5, $zero, 10
		div $t0, $t5
		mflo $v0   
		mfhi $v1	  
		jr $ra

######### FIN PROCEDIMIENTO SepararDigitos ##############################

	#####################################################################
	# Procedimiento: LongitudEntero
	# Utilidad: Devolver la longitud de un número entero
	# Entrada: registro $a0 donde estará almacenado el número a evaluar
	# Salida: $v0 como la cantidad acumulada

LongitudEntero: addi, $v0, $zero, 0
		addi, $t0, $a0, 0
LoopLE:		beqz $t0, FinalLE
		addi $t5, $zero, 10
		div $t0, $t5
		mflo $t6 
		addi $t0, $t6, 0
		addi $v0, $v0, 1
		j LoopLE
FinalLE:        jr $ra
		
	
	
	
