PROGRAM prueba_completa;

INTEGER, PARAMETER :: bloque = 1024;
REAL, PARAMETER :: PI = 3.141592;
CHARACTER(2), PARAMETER :: S = "SI";
CHARACTER(24), PARAMETER :: literal1 = 'comilla doble " dentro';

INTEGER :: contador = 0, control = 2, total = 0, i;
REAL :: resultado = 0.0;
CHARACTER(4) :: b = "hola";
INTEGER :: d = 5, e = 10;

INTERFACE
    SUBROUTINE proc1(c, d, e)
        REAL, INTENT(OUT) c;
        INTEGER, INTENT(IN) d;
        INTEGER, INTENT(INOUT) e;
    END SUBROUTINE proc1
    
    FUNCTION fun1(a, b)
        INTEGER :: fun1;
        INTEGER, INTENT(IN) a;
        CHARACTER(4), INTENT(IN) b;
    END FUNCTION fun1
END INTERFACE

resultado = (total + 50) / 2.0;

DO WHILE (contador < 3)
    contador = contador + 1;
    IF (contador == 2 .AND. .TRUE.) THEN
        total = total + fun1(d, b);
    ELSE
        total = total + 10;
    ENDIF
ENDDO

DO i = 1, 5, 1
    total = total + i;
ENDDO

SELECT CASE (control)
    CASE (1)
        total = total + 100;
    CASE (2, 3, 4)
        total = total + 200;
    CASE DEFAULT
        total = total + 500;
END SELECT

END PROGRAM prueba_completa

SUBROUTINE proc1(c, d, e)
    REAL, INTENT(OUT) c;
    INTEGER, INTENT(IN) d;
    INTEGER, INTENT(INOUT) e;
    c = 5.5;
END SUBROUTINE proc1

FUNCTION fun1(a, b)
    INTEGER :: fun1;
    INTEGER, INTENT(IN) a;
    CHARACTER(4), INTENT(IN) b;
    fun1 = a * 2;
END FUNCTION fun1