public class Llamada extends Sentencia {
    private String ident;
    private String params;

    public Llamada(String ident, String params) {
        this.ident = ident;
        this.params = params;
    }

    @Override
    public String getExp() {
        return "";
    }

    @Override
    public void traducir(Subprograma subActual, Programa programa) {
        Subprograma subLlamado = null;
        for (Subprograma s : programa.getSubprogramas()) {
            if (s.getIdent().equalsIgnoreCase(this.ident)) {
                subLlamado = s;
                break;
            }
        }

        System.out.print(this.ident + "(");
        if (this.params != null && !this.params.isEmpty()) {
            String[] args = this.params.split(",");
            for (int i = 0; i < args.length; i++) {
                String arg = args[i].trim();
                if (subLlamado != null && i < subLlamado.getParams().size()) {
                    Variable param = subLlamado.getParams().get(i);
                    if (param.getLength() == null && param.getIntent() != null &&
                            (param.getIntent().equalsIgnoreCase("OUT") || param.getIntent().equalsIgnoreCase("INOUT"))) {
                        System.out.print("&");
                    }
                }

                System.out.print(arg);
                if (i < args.length - 1) {
                    System.out.print(", ");
                }
            }
        }
        System.out.println(");");
    }
}