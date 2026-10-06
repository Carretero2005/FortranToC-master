import java.util.ArrayList;

public class Programa {
    private String ident;
    private ArrayList<Constante> constantes;
    private ArrayList<Subprograma> subprogramas;
    private Subprograma main;
    private ArrayList<ErrorSemantico> errores;


    public Programa(){
        constantes =new ArrayList<>();
        subprogramas = new ArrayList<>();
        main = new Subprograma();
        main.setIdent("main");
        main.setReturnType("void");
        errores = new ArrayList<>();
    }

    public ArrayList<ErrorSemantico> getErrores() {
        return errores;
    }

    public void addError(int linea, int columna, String causa) {
        errores.add(new ErrorSemantico(linea, columna, causa));
    }

    public boolean hayErrores() {
        return !errores.isEmpty();
    }

    public String getIdent() {
        return ident;
    }

    public void setIdent(String ident) {
        this.ident = ident;
    }

    public ArrayList<Constante> getConstantes() {
        return constantes;
    }

    public void setConstantes(ArrayList<Constante> constantes) {
        this.constantes = constantes;
    }

    public ArrayList<Subprograma> getSubprogramas() {
        return subprogramas;
    }

    public void setSubprogramas(ArrayList<Subprograma> subprogramas) {
        this.subprogramas = subprogramas;
    }

    public Subprograma getMain() {
        return main;
    }

    public void setMain(Subprograma main) {
        this.main = main;
    }

    public void traducir(){

        //busca errores
        boolean semanticaCorrecta = ValidadorSemantico.validar(this);
        if (!semanticaCorrecta || hayErrores()) {
            errores.sort((a, b) -> {
                if (a.getLinea() != b.getLinea()) return Integer.compare(a.getLinea(), b.getLinea());
                return Integer.compare(a.getColumna(), b.getColumna());
            });
            System.err.println("Se han detectado " + errores.size() + " error(es):");
            for (ErrorSemantico e : errores) {
                System.err.println("  " + e);
            }
            System.err.println("Traduccion cancelada.");
            return;
        }

        //imprime constantes
        if (!constantes.isEmpty()) {
            for (Constante declaration : constantes) {
                System.out.print("#define ");
                declaration.traducirCte();
            }
            System.out.print("\n");
        }

        //imprime cabeceras de funciones
        if (!subprogramas.isEmpty()) {
            for (Subprograma value : subprogramas) {
                value.traducirCabecera();
            }
            System.out.print("\n");
        }

        //impime main
        System.out.print("void ");
        System.out.print(main.getIdent());
        System.out.print(" ( void ) ");
        System.out.println("{");
        main.traducirDcls();

        //imprime sentencias
        for (Sentencia s: main.getSentList()){
            System.out.print("\t");
            s.traducir(main, this);
        }

        System.out.println("}");

        //imprime subprogramas
        for (Subprograma subprograma : subprogramas) {
            subprograma.traducirBody(this);
        }
    }
}
