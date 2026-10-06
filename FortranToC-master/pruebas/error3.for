PROGRAM test_switch_error;

INTEGER :: estado = 2;

SELECT CASE (estado)
    CASE 1
        estado = 0;
    CASE DEFAULT
        estado = 1;
END SELECT

END PROGRAM test_switch_error