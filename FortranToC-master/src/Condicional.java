import java.util.ArrayList;

public class Condicional extends Sentencia{
    private String condicion;             // la cadena de la condición ya traducida
    private ArrayList<Sentencia> bloqueThen;
    private ArrayList<Sentencia> bloqueElse;  // null si no hay ELSE

    public Condicional(String condicion, ArrayList<Sentencia> bloqueThen, ArrayList<Sentencia> bloqueElse) {
        this.condicion = condicion;
        this.bloqueThen = bloqueThen;
        this.bloqueElse = bloqueElse;
    }

    @Override
    public void traducir(Subprograma subActual, Programa programa) {
        System.out.println("if(" + condicion + ") {");
        for (Sentencia s : bloqueThen) {
            System.out.print("\t\t");
            s.traducir( subActual,  programa);
        }
        if (bloqueElse != null) {
            System.out.println("\t} else {");
            for (Sentencia s : bloqueElse) {
                System.out.print("\t\t");
                s.traducir( subActual,  programa);
            }
        }
        System.out.println("\t}");
    }
}
