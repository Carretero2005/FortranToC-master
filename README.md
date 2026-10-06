# Traductor de lenguaje de cálculo científico (tipo Fortran) a C

Práctica obligatoria de la asignatura **Procesadores de Lenguajes** · Grado en Ingeniería Informática · Universidad Rey Juan Carlos (URJC).

Traductor que toma como entrada programas escritos en un lenguaje de cálculo científico similar a Fortran y genera como salida su equivalente en un lenguaje similar a C. Incluye un sistema de notificación y recuperación de errores.

## Autores

- Matias Maccarrone
- Alejandro Carretero
- Raúl Sánchez López

## Tecnologías

- **Java**
- **ANTLR 4**: generador de analizadores léxicos y sintácticos
- Gramática en notación BNF, transformada a LL(1) en su mayoría
- Traducción dirigida por la sintaxis mediante acciones semánticas embebidas en la gramática

## Funcionalidades

**Parte obligatoria:** cubierta en su totalidad.

**Ampliaciones opcionales implementadas:**

- Constantes en base binaria, octal y hexadecimal
- Constantes y operadores lógicos
- Sentencias de control de flujo: `IF`, `DO WHILE`, `DO` y `SELECT CASE`
- Traducción de parámetros `OUT` e `INOUT` mediante punteros
- Sistema de notificación de errores
- Sistema de recuperación de errores

## Cómo funciona

La aplicación sigue estas fases:

1. **Análisis léxico y sintáctico** con ANTLR 4.
2. **Modelado del programa** con un conjunto de clases Java (`Programa`, `Subprograma`, `Variable`, `Sentencia` y sus derivadas), que representan la estructura del programa fuente durante el análisis y se encargan de emitir el código final.
3. **Traducción:** al terminar el análisis se invoca `Programa.traducir()`. Si hubo errores, se notifican y **no se imprime código C**. Si no los hubo, se imprime el código traducido.

### Reglas léxicas

Los símbolos (`(`, `+`, `=`, `,`...) se dejan como literales entrecomillados en las reglas sintácticas para que la gramática sea más legible. Los tokens léxicos se reservan para:

- **Palabras reservadas:** `PROGRAM`, `INTERFACE`, `FUNCTION`, `SUBROUTINE`, `PARAMETER`, `INTENT`, `INTEGER`, `REAL`, `CHARACTER`, `CASE`, `.TRUE.`, `.OR.`...
- **Elementos de contenido variable:**
  - `IDENT`: identificadores
  - `NUM_INT_CONST`: constantes enteras
  - `NUM_REAL_CONST`: constantes reales (punto fijo, exponencial y mixta)
  - `STRING_CONST`: cadenas con comillas simples o dobles
- **Reglas descartadas (`-> skip`):** `COMENT` (comentarios que empiezan por `!`) y `WS` (espacios, tabulaciones y saltos de línea).

### Transformación a LL(1)

Pasos seguidos:

1. Se fijaron las normas: no recursión por la izquierda y conjuntos directores que no coincidan.
2. Se eliminó la recursión por la izquierda, transformando `A → Aα | β` en `A → βA'`, `A' → αA' | λ`.
3. Se calcularon los conjuntos cabecera, siguiente y director para detectar coincidencias y se factorizaron las reglas.

Ejemplo (`nomparamlist`):

```
nomparamlist  ::= IDENT | IDENT "," nomparamlist      // los directores coinciden

nomparamlist  ::= IDENT nomparamlistp
nomparamlistp ::= λ | "," nomparamlist                // solución
```

**Conflictos que persisten.** Tres reglas siguen solapando sus conjuntos directores y las resuelve el lookahead adaptativo de ANTLR (LL(\*)):

| Regla | Solapamiento | Cómo se resuelve |
|---|---|---|
| `dec_s_paramlist` | `{ INTEGER, REAL, CHARACTER }` | Mira si tras el tipo aparece `,` (parámetro) o `::` (declaración local) |
| `dec_f_paramlist` | `{ INTEGER, REAL, CHARACTER }` | Igual que la anterior, en el contexto de funciones |
| `factorcond` | `{ '(' }` | Mira si hay un operador de comparación dentro del paréntesis |

## Notificación y recuperación de errores

### Arquitectura

- **`ErrorSemantico`**: modelo de datos con línea, columna y causa del error.
- **`Programa`**: contenedor central con un `ArrayList<ErrorSemantico>`, gestionado con `addError(linea, columna, causa)`.
- **`NotificationError`**: extiende `BaseErrorListener` de ANTLR. Intercepta los errores del lexer y del parser, los traduce al español y los envía a `Programa`. Cuando es posible, añade una sugerencia del tipo *"Se esperaba: {...}"*.

### Detección

- **Léxica y sintáctica (automática):** `NotificationError` procesa las excepciones nativas de ANTLR (`missing`, `mismatched`, `no viable alternative`).
- **Semántica (acciones en la gramática):** métodos auxiliares definidos en `@parser::members` que se ejecutan en `decproc`, `decfun`, `codproc` y `codfun`:
  - `semErr(token, causa)`: registra el error con la posición del token.
  - `chkEndIdent`: comprueba que el identificador de apertura y el de cierre coinciden.
  - `chkParamNames`: compara número y nombre de los parámetros de la cabecera con los declarados.
  - Validación de funciones: el tipo de retorno debe coincidir con el nombre de la función y la última sentencia debe ser una asignación a ese identificador.

### Recuperación

Los errores no abortan el análisis. Se aplica el **modo pánico** nativo de ANTLR, que descarta o inserta tokens hasta sincronizarse con un delimitador seguro (`;` o `END`). Así se detectan varios errores en una sola ejecución, aunque una línea muy dañada puede provocar una cadena de avisos hasta que el parser se recupere.

## Casos de prueba

### Correctos

| Fichero | Qué prueba |
|---|---|
| `Ok1.for` | Constantes numéricas en todas las bases y tipos, cadenas con alternancia de comillas, variables con inicialización y arrays |
| `Ok2.for` | `INTERFACE`, `SUBROUTINE` y `FUNCTION`, parámetros `IN`/`INOUT`/`OUT`, llamadas con `CALL` y a funciones |
| `Ok3.for` | `IF` con operadores lógicos, `DO WHILE` y `DO` iterativo |
| `Ok4.for` | `SELECT CASE` con valores, listas, rangos (`5:10`, `:0`) y `DEFAULT` |
| `Ok5.for` | Programa completo que combina todo lo anterior |

### Erróneos

| Fichero | Tipo de error | Descripción |
|---|---|---|
| `Error1.for` | Semántico | Nombres de apertura y cierre distintos en el programa y en la función, parámetro `INTENT(IN)` no incluido en la cabecera, tipo de retorno asociado a un nombre incorrecto y falta de la asignación final de retorno |
| `Error2.for` | Léxico | Operador `.LT.` no reconocido (el lenguaje usa `<`) |
| `Error3.for` | Sintáctico | `CASE 1` en lugar de `CASE (1)` |
| `Error4.for` | Sintáctico | Falta el `;` al final de la declaración del parámetro dentro de una `INTERFACE` |

Ejemplo de entrada con error (`Error3.for`):

```fortran
PROGRAM test_switch_error;

INTEGER :: estado = 2;

SELECT CASE (estado)
    CASE 1
        estado = 0;
    CASE DEFAULT
        estado = 1;
END SELECT

END PROGRAM test_switch_error
```




