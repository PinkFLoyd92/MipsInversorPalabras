        #Proyecto Assembly
        .data
mensaje1: .asciiz "\"Ingrese la palabra a manejar\n"
mensaje2: .asciiz "\"Leida palabra con exito \n"
mensajeInversion:	.asciiz "\"Inicio de inversion de palabra\n"
texto:
        .space 40	#40 bytes como maximo para palabra
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
	# syscall			#imprimimos la longitud

	#slt $s2, $s2,$s2

	#validar longitud entre 5 y 20.
	slti	$s2, $a0,5	# a0<5? s2= 1 else s2=0
	bne	$s2, $0, main	# s2 != 0? vamos al main.
	slti 	$s2, $a0, 21	# a0<21? s2=1 else s2=0
	beq	$s2, $0, main	#si s2=0 vamos a main
	j principal_inversion
	
principal_inversion:	
	jal espejo 		#saltamos a la funcion espejo y mostramos la palabra.

	#imprimir mensaje en pantalla
        add   	$v0 , $0 , 4
	la    	$a0 , mensajeInversion
	syscall    #printing mensaje1

	j finalizar
	


	
longitudTexto:
	lb 	$t1, 0($a0)		#cargamos el caracter a v0
	beqz	$t1, exit
	addi	$s0, $s0, 1		#aumentamos el contador
	addi	$a0, $a0, 1		#apuntamos al siguiente valor del string.
	j 	longitudTexto
	# texto en $a0
espejo:
	la	$a0, texto
	li      $t0,0          # push un null en la pila
        subu    $sp,$sp,4      
        sw      $t0,($sp)      
	li      $t1,0          # indice del primer caracter
        # hacer push a caracter
pushl:
        lbu     $t0,texto($t1)   # cargar caracter inicial
        beqz    $t0,stend      # si aparece el byte de null.
        
        subu    $sp,$sp,4      # hacemos push a toda la palabra
        sw      $t0,($sp)      # holding the char
        
        addu    $t1,1          # incrementar el indice.
        j       pushl          # loop

	
stend:  li      $t1,0          # indice del primer caracter en el buffer
	li 	$s0,20
popl:
        lw      $t0,($sp)      # pop del caracter de la pila.
        addu    $sp,$sp,4
        beqz    $t0,done       # si es 0 la pila esta vacia

	jal	transformarCaracter
        sb      $t0,texto($s0)   # guardamos el caracter que falta
        addu    $s0,1          # incrementamos el indice
        j       popl           # loop

        # imprimir la palabra invertida
done:
	li      $v0,4                    
        la      $a1,texto    	#impresion de la palabra invertida
        #syscall
	li $s2, 20
	jal imprimirCaracteres
        li      $v0,10        # exit
        syscall   
	
	jr $ra
exit:	
	jr $ra
transformarCaracter:
	slti	$s2, $t0,97			# t0<98? s2= 1 else s2=0
	bne	$s2, $0, decrementarCaracter	# s2 != 0? vamos a decrementar.
	j	incrementarCaracter
decrementarCaracter:
	addi $t0, 32
	j	fin_transformar
incrementarCaracter:
	addi $t0, -32
	j fin_transformar
fin_transformar:	
	jr $ra

imprimirCaracteres:
	slti $t4, $s2, 60 #s2<40 1 else 0
	lb $a0, 0($a1)
	li $v0, 11    # print_character
	syscall
	beq $t4, $zero, finalizarImpresion
	addi $s2, $s2, 1
	addi $a1,1
	j imprimirCaracteres
finalizarImpresion:	
	jr $ra
	
finalizar:
	li $v0, 10
	syscall
