PROGRAM test_estructuras;

INTEGER :: flag = 1, contador = 0, total = 0, i;

! Condicional compuesto con operadores lógicos
IF (flag == 1 .AND. contador<total) THEN
    total = total + 100;
ELSE
    total = 0;
ENDIF

! Bucle DO WHILE
DO WHILE (contador < 3)
    contador = contador + 1;
ENDDO

! Bucle DO iterativo (Equivalente al for en C)
DO i = 1, 10, 2
    total = total + i;
ENDDO

END PROGRAM test_estructuras