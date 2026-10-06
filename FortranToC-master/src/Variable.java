public class Variable {
    private String tipo;    //int, float, char
    private String ident;   //nombre
    private String length;  //para char[length] si no null
    private String valor;   // valor inicial o null
    private String intent;

    public Variable(String tipo, String ident, String length, String valor) {
        this.tipo = tipo;
        this.ident = ident;
        this.length = length;
        this.valor = valor;
        this.intent = null;
    }

    public Variable(String tipo, String ident, String length, String valor, String intent) {
        this.tipo = tipo;
        this.ident = ident;
        this.length = length;
        this.valor = valor;
        this.intent = intent;
    }

    public String getIntent() {
        return intent;
    }

    public void setIntent(String intent) {
        this.intent = intent;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getIdent() {
        return ident;
    }

    public void setIdent(String ident) {
        this.ident = ident;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }

    public String getValor() {
        return valor;
    }

    public void setValor(String valor) {
        this.valor = valor;
    }


    public String traducirVar() {
        StringBuilder sb = new StringBuilder();
        sb.append(ident);
        if (length != null) {
            sb.append("[").append(length).append("]");
        }
        if (valor != null) {
            sb.append(" = ").append(valor);
        }
        return sb.toString();
    }
    public void traducirParam() {
        System.out.print(tipo + " ");
        if (length == null && intent != null && (intent.equalsIgnoreCase("OUT") || intent.equalsIgnoreCase("INOUT"))) {
            System.out.print("*");
        }
        System.out.print(ident);

        if (length != null) {
            System.out.print("[]");
        }
    }

}
