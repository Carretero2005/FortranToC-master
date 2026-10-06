public abstract class Sentencia {
    String ident;
    String exp;

    public String getIdent() {
        return ident;
    }
    public String getExp(){return exp;}
    public void traducir(Subprograma subActual, Programa programa){}

}
