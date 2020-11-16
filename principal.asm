#Arquitectura de Computador y Laboratorio
#2020-01
#Jhon Vásquez y Brandon Duque
#Universidad de Antioquia 

.data 
archivoEntrada: .asciiz "archivo.txt"
archivoSalida: .asciiz "archivoSalida.txt"
sentence: .byte 0x0A, 0x0D, 0x0A, 0x0D
mensaje01: .asciiz "Ingresa la cantidad de cadenas de caracteres a identificar"
mensaje02: .asciiz "Ingresa la cadena de caracter"

.align 2
textoEntrada .space 20000

.text 

Main: #Abrir (para lectura) un archivo
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
	
	
	
	

