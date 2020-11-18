# Arquitectura de Computadores y Laboratorio
# 2020-01
# Jhon Vásquez y Brandon Duque
# Universidad de Antioquia 

.data 
archivoEntrada: .asciiz "archivo.txt"
archivoSalida: .asciiz "archivoSalida.txt"
sentence: .byte 0x0A, 0x0D, 0x0A, 0x0D
mensaje01: .asciiz "Ingresa la cantidad de cadenas de caracteres a identificar"
mensaje02: .asciiz "Ingresa la cadena de caracteres"
mensaje03: .asciiz "El programa ha finalizado, puedes ir a la carpeta donde está el ejecutable de mars para verificar el archivo"

.align 2
textoEntrada: .space 20000 #Buffer para almacenar el texto que se lee en el archivo

.align 2
cadenaAbuscar: .space 200 #Cadena que ingresa el usuario para buscar

.text 

Main: # Abrir (para lectura) un archivo
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
	
	# Pedir al usuario la cantidad de caracteres a identificar
	li $v0, 4 #syscall para imprimir un mensaje en consola
	la $a0, mensaje01 #mensaje a imprimir
	syscall
	
	# Se obtiene el número de cadenas de caracteres a identificar ingresado por el usuario
	li $v0, 5 #syscall para leer un entero ingresado en la consola
	syscall
	
	# Se guarda el número ingresado por el usuario 
	move $t3,$v0 #hacer una copia del entero ingresado por el usuario en el registro $s3
	
	li $s3, 0 # se le asigna al registro $t0 el valor de 0 (funcionará como i)
	
	#li $v0, 4 #SYSCALL para imprimir un mensaje en consola
	#la $t0, textoEntrada
	#lb $a0, 1($t0)
	#li $v0, 11
	#syscall
	
	#El siguiente loop se encarga de ejecutar el programa hasta que sea completado
	# el número de búsquedas que desea el usuario
      	
Loop01:	#textoEntrada Se empieza el primer while
	li $t4, 0 # $t4 funcionará cowcv7 umo un contador para el siguiente ciclo llamado j (se le asigna el valor de 0)
	li $v0, 4 # mostrar mensaje a usuario
	la $a0, mensaje02 
	syscall
	li $v0, 8  #Se guarda el texto ingresado por el usuario
	la $a0, cadenaAbuscar
	li $a1, 200
	syscall
	slt $at, $s3, $t3 # if ($s3 < $t3) returns 1
	bnez $at, Loop02  #se realiza la comparacion if($at != 0)
	j Exit
	## Se ejecuta el while que va a leer todos los caracteres del archivo 
Loop02:	la $t1, textoEntrada #guardar la dirección del texto de entrada
	add $t1, $t1, $t4 #se le suma j a la dirección de memoria del texto
	#lb $a0, 0($t1) # se usa la instrucción load byte para cargar el byte desde la memoria
	slt $at, $t4, $s2 # if ($t4 < $s2) returns 1
	beqz $at, endLoop01  #se realiza la comparacion if($at == 0)
	## Se ejecuta el método de búsqueda lineal
	li $v0, 4
	la $a0, cadenaAbuscar
	syscall
	addi $t4, $t4, 1 # j = j+1
	j Loop02 #Se devuelve a la etiqueta Loop
	
endLoop01: addi $s3, $s3, 1 # i = i+1 
	  j Loop01 #Se devuelve a la etiqueta Loop
	
Exit: li $v0, 4 #SYSCALL para imprimir un mensaje en consola
      la $a0, mensaje01 #mensaje a imprimir
      syscall
      li $v0, 10 #SYSCALL para finalizar la ejecución del programa
      syscall
	
	###########################################################################
	# Procedimiento BusquedaLineal
	# Utilidad: 
	# Entrada:
	# Salida:
	
	##########################################################################
	# Procedimiento BuscarCadena
	# Utilidad: 
	# Entrada:
	# Salida:
	
	

