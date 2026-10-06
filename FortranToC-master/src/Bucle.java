import java.util.ArrayList;

public class Bucle extends Sentencia{
    private String condicion;
    private ArrayList<Sentencia> cuerpo;

    public Bucle(String condicion, ArrayList<Sentencia> cuerpo) {
        this.condicion = condicion;
        this.cuerpo = cuerpo;
    }

    @Override
    public void traducir(Subprograma subActual, Programa programa) {
        if (condicion.contains(";")) {
            System.out.println("for(" + condicion + ") {");
        } else {
            System.out.println("while(" + condicion + ") {");
        }

        for (Sentencia s : cuerpo) {
            System.out.print("\t\t");
            s.traducir(subActual, programa);
        }
        System.out.println("\t}");
    }
}
