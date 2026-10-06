import java.io.*;
import org.antlr.v4.runtime.*;

public class MainANTLR {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.err.println("Error: Debes proporcionar la ruta del archivo .for como argumento.");
            return;
        }

        String rutaEntrada = args[0];

        // Comprobar que la extension es .for (case-insensitive)
        if (!rutaEntrada.toLowerCase().endsWith(".for")) {
            System.err.println("Error: El fichero de entrada debe tener extension .for");
            return;
        }

        // Calcular el nombre del fichero de salida (mismo nombre, extension .c)
        String rutaSalida = rutaEntrada.substring(0, rutaEntrada.length() - 4) + ".c";

        // Guardamos la salida estandar original para restaurarla al final
        PrintStream salidaOriginal = System.out;
        PrintStream salidaFichero = null;

        try {
            // 1. Instanciamos el objeto Programa de tu modelo
            Programa programa = new Programa();

            // 2. Instanciamos el Listener unificado pasándole el programa
            NotificationError miManejadorErrores = new NotificationError(programa);

            // Preparar el fichero de entrada para asignarlo al analizador léxico
            CharStream input = CharStreams.fromFileName(rutaEntrada);

            // Crear el objeto correspondiente al analizador léxico
            practicaLexer analex = new practicaLexer(input);

            // Configurar el LEXER para usar el manejador unificado
            analex.removeErrorListeners();
            analex.addErrorListener(miManejadorErrores);

            // Identificar al analizador léxico como fuente de tokens para el sintactico
            CommonTokenStream tokens = new CommonTokenStream(analex);

            // Crear el objeto correspondiente al analizador sintáctico
            practicaParser anasint = new practicaParser(tokens);

            // Configurar el PARSER para usar el manejador unificado (para errores sintácticos automáticos)
            anasint.removeErrorListeners();
            anasint.addErrorListener(miManejadorErrores);

            // Vinculamos los objetos de control al parser antes del análisis
            anasint.setPrograma(programa);
            anasint.setErrorListener(miManejadorErrores);

            // Comenzar el análisis llamando al axioma de la gramática
            anasint.prg();

            // Redirigir System.out al fichero .c antes de traducir
            salidaFichero = new PrintStream(new FileOutputStream(rutaSalida), true, "UTF-8");
            System.setOut(salidaFichero);

            // Traducir (todo lo que se imprime con System.out va al fichero)
            programa.traducir();

            // Restaurar la salida estandar
            System.setOut(salidaOriginal);
            salidaFichero.close();

            // Si hubo errores, borrar el fichero .c (estara vacio o incompleto)
            if (programa.hayErrores()) {
                new File(rutaSalida).delete();
                System.out.println("Se han detectado errores. No se ha generado fichero de salida.");
            } else {
                System.out.println("Traduccion completada. Fichero generado: " + rutaSalida);
            }

        } catch (org.antlr.v4.runtime.RecognitionException e) {
            System.setOut(salidaOriginal);
            if (salidaFichero != null) salidaFichero.close();
            System.err.println("REC " + e.getMessage());
        } catch (IOException e) {
            System.setOut(salidaOriginal);
            if (salidaFichero != null) salidaFichero.close();
            System.err.println("IO " + e.getMessage());
        } catch (java.lang.RuntimeException e) {
            System.setOut(salidaOriginal);
            if (salidaFichero != null) salidaFichero.close();
            System.err.println("RUN " + e.getMessage());
            e.printStackTrace(System.err);
        }
    }
}