import java.util.ArrayList;

public class ValidadorSemantico {

    public static boolean validar(Programa programa) {
        boolean todoCorrecto = true;

        for (Subprograma sub : programa.getSubprogramas()) {
            String nombreSub = sub.getIdent();

            if (nombreSub == null || nombreSub.isEmpty()) {
                programa.addError(0, 0, "Subprograma sin identificador valido.");
                todoCorrecto = false;
                continue;
            }

            ArrayList<Variable> parametrosDeclarados = sub.getParams();
            for (Variable param : parametrosDeclarados) {
                if (param.getIntent() == null) {
                    programa.addError(0, 0,
                            "En '" + nombreSub + "': el parametro '"
                                    + param.getIdent() + "' no tiene una especificacion de INTENT.");
                    todoCorrecto = false;
                }
            }
        }

        return todoCorrecto;
    }
}