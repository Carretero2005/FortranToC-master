import java.util.ArrayList;

public class Switch extends Sentencia {
    private String selector;
    private ArrayList<Caso> casos;

    public Switch(String selector, ArrayList<Caso> casos) {
        this.selector = selector;
        this.casos = casos;
    }

    @Override
    public void traducir(Subprograma subActual, Programa programa) {
        System.out.println("switch (" + selector + ") {");
        for (Caso c : casos) {
            c.traducir(subActual, programa);
        }
        System.out.println("\t}");
    }
}