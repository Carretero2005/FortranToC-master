import java.util.ArrayList;

public class Caso extends Sentencia{
    private String tipo;              // "normal", "rango", "menor", "mayor", "default"
    private ArrayList<String> etiquetas;
    private ArrayList<Sentencia> sentencias;

    public Caso(String tipo, ArrayList<String> etiquetas, ArrayList<Sentencia> sentencias) {
        this.tipo = tipo;
        this.etiquetas = etiquetas != null ? etiquetas : new ArrayList<>();
        this.sentencias = sentencias != null ? sentencias : new ArrayList<>();
    }

    public void traducir(Subprograma subActual, Programa programa) {
        switch (tipo) {
            case "normal":
                for (String e : etiquetas) {
                    System.out.println("\t\tcase " + e + ":");
                }
                break;
            case "rango":
                System.out.println("\t\tcase " + etiquetas.getFirst() + " to " + etiquetas.get(1) + ":");
                break;
            case "menor":
                System.out.println("\t\tcase < " + etiquetas.getFirst() + ":");
                break;
            case "mayor":
                System.out.println("\t\tcase > " + etiquetas.getFirst() + ":");
                break;
            case "default":
                System.out.println("\t\tdefault:");
                break;
        }
        for (Sentencia s : sentencias) {
            System.out.print("\t\t\t");
            s.traducir(subActual, programa);
        }
        if (!tipo.equals("default")) {
            System.out.println("\t\t\tbreak;");
        }
    }
}