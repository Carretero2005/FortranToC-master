public class Constante {
    private String ident;
    private String exp;

    public Constante(String ident, String exp) {
        this.ident = ident;
        this.exp = exp;
    }

    public String getIdent() { return ident; }
    public String getExp() { return exp; }

    public void traducirCte() {
        String expEscapada = exp;

        if (exp != null && exp.length() >= 2) {
            if (exp.startsWith("'") || exp.startsWith("\"")) {
                String contenido = exp.substring(1, exp.length() - 1);

                if (exp.startsWith("'")) {
                    contenido = contenido.replace("''", "'");
                    contenido = contenido.replace("\"", "\\\"");
                } else {
                    contenido = contenido.replace("\"\"", "\"").replace("\"", "\\\"");
                }

                expEscapada = "\"" + contenido + "\"";
            }
        }
        System.out.println(ident + " " + expEscapada);
    }
}