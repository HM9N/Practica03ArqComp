# Arquitectura de Computador y Laboratorio
# 2020-01
# Jhon Vásquez y Brandon Duque
# Universidad de Antioquia 

.data 
archivoEntrada: .asciiz "archivo.txt"
archivoSalida: .asciiz "archivoSalida.txt"
sentence: .byte 0x0A, 0x0D, 0x0A, 0x0D
mensaje01: .asciiz "Ingresa la cantidad de cadenas de caracteres a identificar"
mensaje02: .asciiz "Ingresa la cadena de caracteres"

.align 2
textoEntrada: .space 20000

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
	li $v0, 4
	la $a0, mensaje01
	syscall
	
	# Se obtiene el número de caracteres a identificar ingresado por el usuario
	li $v0, 5
	syscall
	
	# Se guarda el número ingresado por el usuario 
	move $s3,$v0
	
	
	
	
	
	
	
	
	
	
	
	
	###########################################################################
	# Procedimiento BusquedaLineal
	# Utilidad: 
	# Entrada:
	# Salida:
	
	
	
	

