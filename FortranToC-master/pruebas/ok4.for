PROGRAM test_switch;

INTEGER :: opcion = 3, puntuacion = 0;

SELECT CASE (opcion)
    CASE (1)
        puntuacion = 10;
    CASE (2, 3, 4)
        puntuacion = 50;
    CASE (5:10)
        puntuacion = 100;
    CASE (:0)
        puntuacion = -1;
    CASE DEFAULT
        puntuacion = 0;
END SELECT

END PROGRAM test_switch