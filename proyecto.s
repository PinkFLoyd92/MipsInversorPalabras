        #Proyecto Assembly
        .data
mensaje1: .asciiz "\"Ingrese la palabra a manejar\n"
mensaje2: .asciiz "\"Leida palabra con exito \n"
texto:
        .space 20	#20 bytes como maximo para palabra
textoInvertido:
	.space 20
	
        .text		#lo que sigue sera codigo a llamar.	
main:	
	#imprimir mensaje en pantalla
        add   	$v0 , $0 , 4
	la    	$a0 , mensaje1
	syscall    #printing mensaje1

	#ingreso de input
	add	$v0, $v0, 4	#dado que ya tiene 4, al sumar tenemos 8 lo que es requerido.
	la 	$a0, texto
	li	$a1, 20		#size del string
	syscall

	#imprimir mensaje de exito de lectura en pantalla
        sub   	$v0 ,$v0 , 4
	la    	$a0 , mensaje2
	syscall    #printing mensaje2
	# proceso obtener longitud real de palabra

	li 	$s0, 0		#s0 es usada para contar los caracteres $s0 = 0
	la 	$a0, texto

	#validacion de longitud
	jal longitudTexto
	
	#impresion de longitud
	li	$v0, 1
	sub	$a0, $s0, 1	#tenemos la longitud.
	#syscall			#imprimimos la longitud
	slt $s2, $s2,$s2

	#validar longitud entre 5 y 20.
	slt	$s2, 5, $a0	# verificar si a0 > 5
	beq	$s2, $0, main	#si es falso(a0>5) vamos a main
	slt 	$s2, $a0, 20	# verificar si a0 <20
	beq	$s2, $0, main	#si es falso(a0>20) vamos a main
	j principal_inversion
	
principal_inversion:	
	jal espejo 		#saltamos a la funcion espejo y mostramos la palabra.
	jr      $raq



	
longitudTexto:
	lb 	$t1, 0($a0)		#cargamos el caracter a v0
	beqz	$t1, exit
	addi	$s0, $s0, 1		#aumentamos el contador
	addi	$a0, $a0, 1		#apuntamos al siguiente valor del string.
	j 	longitudTexto
espejo:
	jr $ra
exit:	
	jr $ra
