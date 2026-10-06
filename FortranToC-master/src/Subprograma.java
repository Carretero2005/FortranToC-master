import java.util.ArrayList;

public class Subprograma {
    private String ident;
    private String returnType;
    private ArrayList<Variable> params = new ArrayList<>();
    private ArrayList<Variable> dcllist = new ArrayList<>();
    private ArrayList<Sentencia> sentList = new ArrayList<>();

    public String getIdent() {
        return ident;
    }

    public void setIdent(String ident) {
        this.ident = ident;
    }

    public String getReturnType() {
        return returnType;
    }

    public void setReturnType(String returnType) {
        this.returnType = returnType;
    }

    public ArrayList<Variable> getParams() {
        return params;
    }

    public void setParams(ArrayList<Variable> params) {
        this.params = params;
    }

    public ArrayList<Sentencia> getSentList() {
        return sentList;
    }

    public void setSentList(ArrayList<Sentencia> sentList) {
        this.sentList = sentList;
    }

    public ArrayList<Variable> getDcllist() { return dcllist; }

    public void setDcllist(ArrayList<Variable> dcllist) { this.dcllist = dcllist; }

    void traducirCabecera() {   //para INTERFACE
        System.out.print(returnType + " ");
        System.out.print(ident);
        System.out.print("( ");

        if (params.isEmpty()) {
            System.out.print("void");
        } else {
            for (int i = 0; i < params.size(); i++) {
                params.get(i).traducirParam();
                if (i < params.size() - 1) System.out.print(" , ");
            }
        }
        System.out.println(" );");
    }

    void traducirBody(Programa programa) {   //sentencias
        System.out.print("\n" + returnType + " ");
        System.out.print(ident);
        System.out.print("( ");

        if (params.isEmpty()) {
            System.out.print("void");
        } else {
            for (int i = 0; i < params.size(); i++) {
                params.get(i).traducirParam();
                if (i < params.size() - 1) System.out.print(" , ");
            }
        }
        System.out.println(" ) {");

        traducirDcls();

        for (int i = 0; i < sentList.size(); i++) {
            Sentencia s = sentList.get(i);
            System.out.print("\t");

            boolean esUltimo = (i == sentList.size() - 1);

            if (!returnType.equals("void") && esUltimo) {
                String expresionRetorno = s.getExp();
                for (Variable p : this.getParams()) {
                    if (p.getLength() == null && p.getIntent() != null &&
                            (p.getIntent().equalsIgnoreCase("OUT") || p.getIntent().equalsIgnoreCase("INOUT"))) {
                        expresionRetorno = expresionRetorno.replaceAll("\\b" + p.getIdent() + "\\b", "*" + p.getIdent());
                    }
                }
                System.out.println("return " + expresionRetorno + ";");
            } else {
                s.traducir(this, programa);
            }
        }

        System.out.println("}");
    }

    void traducirDcls() {   //declaraciones
        if (dcllist.isEmpty()) return;

        String tipoActual = null;
        StringBuilder linea = new StringBuilder();

        for (Variable d : dcllist) {
            if (tipoActual == null) {
                tipoActual = d.getTipo();
                linea.append("\t").append(tipoActual).append(" ").append(d.traducirVar());
            } else if (d.getTipo().equals(tipoActual)) {
                linea.append(", ").append(d.traducirVar());
            } else {
                System.out.println(linea.toString() + ";");
                tipoActual = d.getTipo();
                linea.setLength(0);
                linea.append("\t").append(tipoActual).append(" ").append(d.traducirVar());
            }
        }
        System.out.println(linea.toString() + ";");
    }
}