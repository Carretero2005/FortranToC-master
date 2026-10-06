import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.IntervalSet;

public class NotificationError extends BaseErrorListener {
    private final Programa programa;
    private int errorCount = 0;

    public NotificationError(Programa programa) {
        this.programa = programa;
    }

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer,
                            Object offendingSymbol,
                            int line,
                            int charPositionInLine,
                            String msg,
                            RecognitionException e) {
        errorCount++;
        String causaEnEspaniol = msg;

        String esperados = "";
        if (recognizer instanceof Parser parser) {
            int estadoActual = parser.getState();
            RuleContext contextoActual = parser.getContext();

            IntervalSet expectedTokens = parser.getATN().getExpectedTokens(estadoActual, contextoActual);

            if (!expectedTokens.isNil()) {
                esperados = expectedTokens.toString(parser.getVocabulary());
            }
        }

        if (offendingSymbol instanceof Token) {
            Token t = (Token) offendingSymbol;
            String textoToken = t.getText();

            if (msg.contains("missing")) {
                causaEnEspaniol = "Error Sintáctico: Falta un elemento obligatorio cerca de '" + textoToken + "'.";
                if (!esperados.isEmpty()) causaEnEspaniol += " Se esperaba uno de los siguientes: " + esperados;
            } else if (msg.contains("mismatched input")) {
                causaEnEspaniol = "Error Sintáctico: Se encontró '" + textoToken + "' pero no coincide con la estructura esperada.";
                if (!esperados.isEmpty()) causaEnEspaniol += " Se esperaba: " + esperados;
            } else if (msg.contains("no viable alternative")) {
                causaEnEspaniol = "Error Sintáctico: Estructura inválida o incompleta al procesar '" + textoToken + "'.";
                if (!esperados.isEmpty()) causaEnEspaniol += "Se esperaba: " + esperados;
            }else if (msg.contains("extraneous")) {
                causaEnEspaniol = "Error Sintáctico: Elemento inesperado o fuera de lugar: '" + textoToken + "'. Revise la estructura o los paréntesis del bloque.";
            }
        } else {
            if (msg.contains("token recognition error at")) {
                String caracterInvalido = msg.substring(msg.indexOf("'"));
                causaEnEspaniol = "Error Léxico: Carácter o símbolo no válido en el lenguaje: " + caracterInvalido;
            }
        }

        if (esperados.isEmpty() && msg.contains("expecting")) {
            String loQueEsperabaAntlr = msg.substring(msg.indexOf("expecting"));
            loQueEsperabaAntlr = loQueEsperabaAntlr.replace("expecting", "se esperaba:");
            causaEnEspaniol += " (" + loQueEsperabaAntlr + ")";
        }

        if (programa != null) {
            programa.addError(line, charPositionInLine, causaEnEspaniol);
        } else {
            System.err.println("ERROR linea " + line + ":" + charPositionInLine + "->" + causaEnEspaniol);
        }
    }

    public void addSemanticError(int linea, int columna, String causa) {
        errorCount++;
        if (programa != null) {
            programa.addError(linea, columna, "Error Semántico: " + causa);
        } else {
            System.err.println("ERROR Semántico linea " + linea + ":" + columna + "->" + causa);
        }
    }

    public int getErrorCount() { return errorCount; }
    public boolean hasErrors() { return errorCount > 0; }
}