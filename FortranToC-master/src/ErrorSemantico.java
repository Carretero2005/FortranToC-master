public class ErrorSemantico {
    private final int linea;
    private final int columna;
    private final String causa;

    public ErrorSemantico(int linea, int columna, String causa) {
        this.linea = linea;
        this.columna = columna;
        this.causa = causa;
    }

    public int getLinea()   { return linea; }
    public int getColumna() { return columna; }
    public String getCausa(){ return causa; }

    @Override
    public String toString() {
        return "[linea " + linea + ", columna " + columna + "]: " + causa;
    }
}
