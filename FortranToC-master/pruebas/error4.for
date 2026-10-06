PROGRAM test_interface_error;

INTERFACE
    SUBROUTINE proceso_corto(x, y)
        REAL, INTENT(IN) x;
        REAL, INTENT(OUT) y
    END SUBROUTINE proceso_corto
END INTERFACE

END PROGRAM test_interface_error