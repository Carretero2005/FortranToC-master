public class Expresion extends Sentencia {
    private String ident;
    private String exp;

    public Expresion(String ident, String exp) {
        this.ident = ident;
        this.exp = exp;
    }

    @Override
    public String getExp() {
        return this.exp;
    }
    @Override
    public String getIdent() {
        return this.ident;
    }

    @Override
    public void traducir(Subprograma subActual, Programa programa) {
        String parteIzquierda = this.ident.trim();
        String parteDerecha = this.exp.trim();

        if (subActual != null && subActual.getParams() != null) {
            for (Variable p : subActual.getParams()) {
                if (p.getIdent().equalsIgnoreCase(parteIzquierda)) {
                    if (p.getLength() == null && p.getIntent() != null &&
                            (p.getIntent().equalsIgnoreCase("OUT") || p.getIntent().equalsIgnoreCase("INOUT"))) {
                        parteIzquierda = "*" + parteIzquierda;
                        break;
                    }
                }
            }
        }
        if (subActual != null && subActual.getParams() != null) {
            for (Variable p : subActual.getParams()) {
                if (p.getLength() == null && p.getIntent() != null &&
                        (p.getIntent().equalsIgnoreCase("OUT") || p.getIntent().equalsIgnoreCase("INOUT"))) {
                    parteDerecha = parteDerecha.replaceAll("\\b" + p.getIdent() + "\\b", "*" + p.getIdent());
                }
            }
        }
        System.out.println(parteIzquierda + " = " + parteDerecha + ";");
    }
}