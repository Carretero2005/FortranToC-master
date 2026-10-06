PROGRAM test_subprogramas;

INTEGER :: n1 = 5, n2 = 10;
REAL :: res_out, res_fun;

INTERFACE
    SUBROUTINE CalcularTodo(a, b, c)
        INTEGER, INTENT(IN) a;
        INTEGER, INTENT(INOUT) b;
        REAL, INTENT(OUT) c;
    END SUBROUTINE CalcularTodo

    FUNCTION Multiplicar(x, y)
        REAL :: Multiplicar;
        REAL, INTENT(IN) x;
        REAL, INTENT(IN) y;
    END FUNCTION Multiplicar
END INTERFACE

CALL CalcularTodo(n1, n2, res_out);
res_fun = Multiplicar(res_out, 2.0);

END PROGRAM test_subprogramas

SUBROUTINE CalcularTodo(a, b, c)
    INTEGER, INTENT(IN) a;
    INTEGER, INTENT(INOUT) b;
    REAL, INTENT(OUT) c;
    INTEGER :: calculo_interno;
    b = b + a;
    c = 5.5;
END SUBROUTINE CalcularTodo

FUNCTION Multiplicar(x, y)
    REAL :: Multiplicar;
    REAL, INTENT(IN) x;
    REAL, INTENT(IN) y;
    Multiplicar = x * y;
END FUNCTION Multiplicar