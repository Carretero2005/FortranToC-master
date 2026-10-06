PROGRAM test_declaraciones;

! Constantes numéricas en todas sus bases y tipos
INTEGER, PARAMETER :: c_int = 1024;
REAL, PARAMETER :: c_real = 3.1415, c_exp = 1.2e-3;
INTEGER, PARAMETER :: c_bin = b'10101', c_oct = o'755', c_hex = z'A4F';

! Constantes de caracteres con alternancia de comillas
CHARACTER(2), PARAMETER :: c_str1 = "SI";
CHARACTER(22), PARAMETER :: c_str2 = 'comilla doble " dentro';
CHARACTER(23), PARAMETER :: c_str3 = "comilla simple ' dentro";
CHARACTER(23), PARAMETER :: c_str4 = 'comilla simple '' dentro';
CHARACTER(22), PARAMETER :: c_str5 = "comilla doble "" dentro";
CHARACTER(32), PARAMETER :: c_str6 = 'comilla doble " y simple '' dentro';
CHARACTER(32), PARAMETER :: c_str7 = "comilla simple ' y doble "" dentro";

! Variables con inicialización, arrays y diferentes tipos
INTEGER :: var_simple, var_init = 42;
REAL :: real_simple, real_init = 0.5;
CHARACTER :: char_simple, char_init = "-";
CHARACTER(10) :: cadena_array1, cadena_array2;
CHARACTER(4) :: palabra = "hola";

END PROGRAM test_declaraciones