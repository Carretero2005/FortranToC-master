grammar practica;

@parser::header{
    import java.util.ArrayList;
    import org.antlr.v4.runtime.Token;
}

@parser::members{
    private Programa program = new Programa();
    private NotificationError errorListener;

    // Método setter para configurar el listener desde MainANTLR
    public void setErrorListener(NotificationError listener) {
        this.errorListener = listener;
    }

    public void setPrograma(Programa prog) {
            this.program = prog;
    }

    private void semErr(Token tok, String causa) {
            if (errorListener != null) {
                errorListener.addSemanticError(tok.getLine(), tok.getCharPositionInLine() + 1, causa);
            } else {
                program.addError(tok.getLine(), tok.getCharPositionInLine() + 1, "Error Semántico: " + causa);
            }
        }

    private void chkEndIdent(String contexto, Token ini, Token fin) {
        if (ini != null && fin != null && !ini.getText().equals(fin.getText())) {
            semErr(fin, "El identificador de fin de " + contexto + " ('"
                + fin.getText() + "') no coincide con el del inicio ('"
                + ini.getText() + "', linea " + ini.getLine() + ").");
        }
    }

    private void chkParamNames(String contexto, Token nombreSub, ArrayList<Token> nombresParen, ArrayList<Token> nombresDecl) {
        if (nombresParen.size() != nombresDecl.size()) {
            semErr(nombreSub, "En " + contexto + " '" + nombreSub.getText()
                        + "': numero de parametros entre parentesis ("
                        + nombresParen.size() + ") no coincide con el numero de parametros declarados ("
                        + nombresDecl.size() + ").");
        }
        int n = Math.min(nombresParen.size(), nombresDecl.size());
        for (int i = 0; i < n; i++) {
            Token p = nombresParen.get(i);
            Token d = nombresDecl.get(i);
            if (!p.getText().equals(d.getText())) {
                semErr(d, "En " + contexto + " '" + nombreSub.getText()
                                + "': el parametro declarado '" + d.getText()
                                + "' (posicion " + (i + 1)
                                + ") no coincide con el parametro de la cabecera '"
                                + p.getText() + "' (linea " + p.getLine() + ").");
            }
        }
    }
}

//SECCION 0: Estructura global
prg : PROGRAM ini=IDENT ';' {program.setIdent($ini.text);}
 dcllist[program.getMain()] cabecera sentlist[program.getMain()] END PROGRAM fin=IDENT { chkEndIdent("PROGRAM", $ini, $fin); } subproglist  EOF;

dcllist[Subprograma sub]: dcl[$sub] dcllist[$sub]
    | ;

cabecera : INTERFACE cablist END INTERFACE
    | ;

cablist : decproc decsubprog
    | decfun decsubprog ;

decsubprog: decproc decsubprog
    | decfun decsubprog
    | ;

sentlist[Subprograma sub]  : sent[$sub] sentlistP[$sub] |;
sentlistP[Subprograma sub] : sent[$sub]  sentlistP[$sub]
    | ;

//SECCION 1: Declaraciones
dcl[Subprograma sub] : tipo dcl_body[$sub, $tipo.type, $tipo.length];

dcl_body[Subprograma sub,String type, String length] :  ',' PARAMETER '::' IDENT '=' simpvalue
            {
                program.getConstantes().add(
                    new Constante($IDENT.text, $simpvalue.valor)
                );
            } ctelist ';'
    | '::' varlist[$sub, $type, $length] ';';

ctelist : ','  IDENT '=' simpvalue {
                                        program.getConstantes().add(
                                            new Constante($IDENT.text, $simpvalue.valor)
                                        );
                                    } ctelist
    | ;

simpvalue returns[String valor]:
    NUM_INT_CONST { $valor = $NUM_INT_CONST.text;}
    |NUM_REAL_CONST { $valor = $NUM_REAL_CONST.text;}
    | NUM_INT_CONST_B {
                        String t = $NUM_INT_CONST_B.text;
                        $valor = "0b" + t.substring(2, t.length() - 1);
                      }
    | NUM_INT_CONST_O {
                        String t = $NUM_INT_CONST_O.text;
                        $valor = "0o" + t.substring(2, t.length() - 1);
                      }
    | NUM_INT_CONST_H {
                        String t = $NUM_INT_CONST_H.text;
                        $valor = "0x" + t.substring(2, t.length() - 1);
                      }
    |STRING_CONST { $valor = $STRING_CONST.text;}
    ;

tipo returns[String type, String length]: INTEGER {$type = "int"; $length=null;}
    | REAL {$type = "float";$length=null;}
    | CHARACTER charlength  {$type = "char"; $length= $charlength.length;};

charlength returns[String length]: '(' NUM_INT_CONST ')' {$length = $NUM_INT_CONST.text;}
    | {$length = null;};

varlist[Subprograma sub, String type, String length]: IDENT init {
                                                                     $sub.getDcllist().add(
                                                                         new Variable($type, $IDENT.text, $length, $init.valor)
                                                                     );
                                                                 } varlistP[$sub, $type, $length];

varlistP[Subprograma sub,String type, String length]: ',' IDENT init {
                                                                         $sub.getDcllist().add(
                                                                             new Variable($type, $IDENT.text, $length, $init.valor)
                                                                         );
                                                                     } varlistP[$sub, $type, $length]
    | ;

init returns[String valor]: '=' simpvalue {$valor = $simpvalue.valor;}
    | {$valor = null;};

//SECCION 2: Cabeceras (Interface)
decproc returns[Subprograma sub]
    : SUBROUTINE ini=IDENT
        {
            $sub = new Subprograma();
            $sub.setIdent($ini.text);
            $sub.setReturnType("void");
        }
      formal_paramlist dec_s_paramlist[$sub] END SUBROUTINE fin=IDENT
              {
                  chkEndIdent("SUBROUTINE", $ini, $fin);
                  chkParamNames("SUBROUTINE", $ini, $formal_paramlist.nombres, $dec_s_paramlist.nombres);
                  program.getSubprogramas().add($sub);
              }
    ;

formal_paramlist returns[ArrayList<Token> nombres]
    : '(' nomparamlist ')' { $nombres = $nomparamlist.nombres; }
    | { $nombres = new ArrayList<Token>(); } ;

nomparamlist returns[ArrayList<Token> nombres]
    : IDENT { $nombres = new ArrayList<Token>(); $nombres.add($IDENT); }
      nomparamlistp[$nombres] ;

nomparamlistp[ArrayList<Token> nombres]
    : ',' IDENT { $nombres.add($IDENT); } nomparamlistp[$nombres]
    | ;

dec_s_paramlist[Subprograma sub] returns[ArrayList<Token> nombres]
    : tipo ',' INTENT '(' tipoparam ')' IDENT ';'
        {
            $sub.getParams().add(
                new Variable($tipo.type, $IDENT.text, $tipo.length, null, $tipoparam.tipoParam)
            );
        }
      resto=dec_s_paramlist[$sub]{
                                    $nombres = $resto.nombres;
                                    $nombres.add(0, $IDENT);
                                }
    | {$nombres = new ArrayList<Token>();};

tipoparam returns[String tipoParam] : IN {$tipoParam="IN";} | OUT {$tipoParam="OUT";}| INOUT {$tipoParam="INOUT";};

decfun returns[Subprograma sub]
    : FUNCTION ini=IDENT
        {
            $sub = new Subprograma();
            $sub.setIdent($ini.text);
        }
      '(' npl=nomparamlist ')' tipo '::' med=IDENT ';'
        {
            $sub.setReturnType($tipo.type);
            if (!$med.text.equals($ini.text)) {
                            semErr($med, "En FUNCTION '" + $ini.text
                                    + "': el identificador del tipo de retorno ('"
                                    + $med.text + "') debe coincidir con el nombre de la funcion ('"
                                    + $ini.text + "').");
            }
        }
      dfp=dec_f_paramlist[$sub] END FUNCTION fin=IDENT
        {
            chkEndIdent("FUNCTION", $ini, $fin);
            chkParamNames("FUNCTION", $ini,$npl.nombres, $dfp.nombres);
            program.getSubprogramas().add($sub);
        }
    ;

dec_f_paramlist[Subprograma sub] returns[ArrayList<Token> nombres]
    : tipo ',' INTENT '(' IN ')' IDENT ';'
        {
            $sub.getParams().add(
                new Variable($tipo.type, $IDENT.text, $tipo.length, null, "IN")
            );
        }
      resto=dec_f_paramlist[$sub]
        {
            $nombres = $resto.nombres;
            $nombres.add(0, $IDENT);
        }
    |
        {
            $nombres = new ArrayList<Token>();
        }
    ;

//SECCION 3: Sentencias
sent[Subprograma sub]
    : IDENT '=' exp ';'
        { $sub.getSentList().add(new Expresion($IDENT.text, $exp.texto)); }
   | proc_call[$sub] ';'
   | IF '(' expcond ')' sentIF[$expcond.valor, $sub]
   | DO sentDO[$sub]
   | SELECT CASE '(' exp ')' casos END SELECT
        {
            $sub.getSentList().add(new Switch($exp.texto, $casos.listaDeCasos));
        };

sentDO[Subprograma sub]
    : WHILE '(' expcond ')'
        {
            Subprograma subBucle = new Subprograma();
        }
      sentlist[subBucle] ENDDO
        {
            $sub.getSentList().add(new Bucle($expcond.valor, subBucle.getSentList()));
        }
    | IDENT '=' dv1=doval ',' dv2=doval ',' dv3=doval
          {
              Subprograma subBucleFor = new Subprograma();
          }
          sentlist[subBucleFor] ENDDO
          {
              String initBucle = $IDENT.text + " = " + $dv1.text;
              String condBucle = $IDENT.text + " <= " + $dv2.text;
              String incBucle  = $IDENT.text + " = " + $IDENT.text + " + " + $dv3.text;
              String expresionControl = initBucle + "; " + condBucle + "; " + incBucle;
              $sub.getSentList().add(new Bucle(expresionControl, subBucleFor.getSentList()));
          }
    ;

sentIF[String cond, Subprograma sub]
    : sent[$sub]
    | THEN
        {
            Subprograma subThen = new Subprograma();
            Subprograma subElse = new Subprograma();
        }
      sentlist[subThen] sentIfElse[subElse]
        {
            ArrayList<Sentencia> listaElse = subElse.getSentList().isEmpty() ? null : subElse.getSentList();
            $sub.getSentList().add(new Condicional($cond, subThen.getSentList(), listaElse));
        }
    ;

sentIfElse[Subprograma sub]
    : ENDIF
    | ELSE sentlist[$sub] ENDIF
    ;

exp returns[String texto]
    : factor expp { $texto = $factor.texto + $expp.texto; };

expp returns[String texto]
    : op factor expp { $texto = $op.texto + $factor.texto + $expp.texto; }
    | { $texto = ""; } ;

op returns[String texto]
    : oparit { $texto = $oparit.texto; } ;

oparit returns[String texto]
    : '+' { $texto = "+"; }
    | '-' { $texto = "-"; }
    | '*' { $texto = "*"; }
    | '/' { $texto = "/"; } ;

factor returns[String texto]
    : simpvalue { $texto = $simpvalue.valor; }
    | '(' exp ')' { $texto = "(" + $exp.texto + ")"; }
    | IDENT factorp { $texto = $IDENT.text + $factorp.texto; } ;

factorp returns[String texto]
    : '(' exp explist ')' { $texto = "(" + $exp.texto + $explist.texto + ")"; }
    | { $texto = ""; } ;

explist returns[String texto]
    : ',' exp explist { $texto = ", " + $exp.texto + $explist.texto; }
    | { $texto = ""; } ;

proc_call[Subprograma sub]
    : CALL IDENT subpparamlist
        { $sub.getSentList().add(new Llamada($IDENT.text, $subpparamlist.texto)); } ;

subpparamlist returns[String texto]
    : '(' exp explist ')' { $texto = $exp.texto + $explist.texto; }
    | { $texto = ""; } ;

//SECCION 4: Subpgrograma
subproglist : codproc subproglist
            | codfun  subproglist
            | ;

codproc returns[Subprograma sub]:
        SUBROUTINE ini=IDENT
        {
            $sub = null;
            for (Subprograma s : program.getSubprogramas()) {
                if (s.getIdent().equals($ini.text)) { $sub = s; break; }
            }
            if ($sub == null) {
                $sub = new Subprograma();
                $sub.setIdent($ini.text);
                $sub.setReturnType("void");
                program.getSubprogramas().add($sub);
            }else {
                     $sub.getParams().clear();
                   }
        }
      fpl=formal_paramlist dpl=dec_s_paramlist[$sub]
      dcllist[$sub] sentlist[$sub]
      END SUBROUTINE fin=IDENT {
                                    chkEndIdent("SUBROUTINE", $ini, $fin);
                                    chkParamNames("SUBROUTINE", $ini,$fpl.nombres, $dpl.nombres);
                                }
    ;

codfun returns[Subprograma sub]: FUNCTION ini=IDENT
        {
            $sub = null;
            for (Subprograma s : program.getSubprogramas()) {
                if (s.getIdent().equals($ini.text)) { $sub = s; break; }
            }
            if ($sub == null) {
                $sub = new Subprograma();
                $sub.setIdent($ini.text);
                program.getSubprogramas().add($sub);
            }else {
                $sub.getParams().clear();
            }
        }
      '(' npl=nomparamlist ')' tipo '::' med=IDENT ';'
        {
            if ($sub.getReturnType() == null){
                $sub.setReturnType($tipo.type);
            }
            if (!$med.text.equals($ini.text)) {
                 semErr($med, "En FUNCTION '" + $ini.text
                         + "': el identificador del tipo de retorno ('"
                         + $med.text + "') debe coincidir con el nombre de la funcion ('"
                         + $ini.text + "').");
            }
        }
      dfp=dec_f_paramlist[$sub] dcllist[$sub] sentlist[$sub] END FUNCTION fin=IDENT
      {
           chkEndIdent("FUNCTION", $ini, $fin);
           chkParamNames("FUNCTION", $ini, $npl.nombres, $dfp.nombres);

           ArrayList<Sentencia> lista = $sub.getSentList();
           if (lista == null || lista.isEmpty()) {
               semErr($fin, "En FUNCTION '" + $ini.text
                   + "': debe terminar con una asignacion al nombre de la funcion.");
           } else {
               Sentencia ultima = lista.get(lista.size() - 1);
               if (!(ultima instanceof Expresion)) {
                   semErr($fin, "En FUNCTION '" + $ini.text + "': la ultima sentencia debe ser una asignacion al nombre de la funcion.");
               } else {
                   Expresion asign = (Expresion) ultima;
                   if (asign.getIdent() == null || !asign.getIdent().equals($ini.text)) {
                       semErr($fin, "En FUNCTION '" + $ini.text + "': la parte izquierda de la ultima asignacion ('"+ asign.getIdent() + "') debe ser el nombre de la funcion ('" + $ini.text + "').");
                   }
               }
           }
       }
    ;

//SECCION 5: sentencias de control de flujo (PARTE OPCIONAL)
expcond returns[String valor]: factorcond expcondP { $valor = $factorcond.valor + $expcondP.valor; };

expcondP returns[String valor]: oplog factorcond expcondP { $valor = " " + $oplog.valor + " " + $factorcond.valor + $expcondP.valor; }
        | { $valor = ""; };


oplog returns[String valor]
    : OR    { $valor = "||"; }
    | AND   { $valor = "&&"; }
    | EQV   { $valor = "!^"; }
    | NEQV  { $valor = "^"; }
;

factorcond returns[String valor]
               : e1=exp opcomp e2=exp { $valor = $e1.texto + " " + $opcomp.valor + " " + $e2.texto; }
               | '(' expcond ')' { $valor = "(" + $expcond.valor + ")"; }
               | NOT factorcond { $valor = "!" + $factorcond.valor; }
               | TRUE   { $valor = "1"; }
               | FALSE  { $valor = "0"; }
               ;

opcomp returns[String valor]
    : OP_LT  { $valor = "<"; }
    | OP_GT  { $valor = ">"; }
    | OP_LE  { $valor = "<="; }
    | OP_GE  { $valor = ">="; }
    | OP_EQ  { $valor = "=="; }
    | OP_NE  { $valor = "!="; }
    ;

doval : NUM_INT_CONST | IDENT;

casos returns [ArrayList<Caso> listaDeCasos]
    : CASE casosP
        {
            $listaDeCasos = $casosP.listaDeCasos;
        }
    |
        {
            $listaDeCasos = new ArrayList<Caso>();
        }
    ;

casosP returns [ArrayList<Caso> listaDeCasos]
    : '(' etiquetas ')'
        {
            Subprograma subCaso = new Subprograma();
        }
      sentlist[subCaso] casos
        {
            Caso c = new Caso($etiquetas.et, $etiquetas.listaEtiq, subCaso.getSentList());
            $listaDeCasos = $casos.listaDeCasos;
            $listaDeCasos.add(0, c);
        }
    | DEFAULT
        {
            Subprograma subDefault = new Subprograma();
        }
      sentlist[subDefault]
        {
            Caso c = new Caso("default", new ArrayList<String>(), subDefault.getSentList());
            $listaDeCasos = new ArrayList<Caso>();
            $listaDeCasos.add(c);
        }
    ;

etiquetas returns [ArrayList<String> listaEtiq, String et]
    : simpvalue etiquetaP
        {
            // Propagamos la lista creada por las reglas inferiores
            $listaEtiq = $etiquetaP.listaEtiq;
            // Insertamos al principio el valor inicial que leímos en esta regla
            $listaEtiq.add(0, $simpvalue.valor);
            $et = $etiquetaP.esRango ? "rango" : "normal";
        }
    | ':' simpvalue
        {
            // Caso especial menor que (:0) -> Aquí sí es una lista nueva
            $listaEtiq = new ArrayList<String>();
            $listaEtiq.add($simpvalue.valor);
            $et = "menor";
        }
    ;

etiquetaP returns [ArrayList<String> listaEtiq, boolean esRango]
    : listaetiquetas
        {
            $listaEtiq = $listaetiquetas.listaEtiq;
            $esRango = false;
        }
    | ':' etPP
        {
            // Inicializamos la lista aquí de forma segura
            $listaEtiq = new ArrayList<String>();
            if ($etPP.valor != null) {
                $listaEtiq.add($etPP.valor);
            } else {
                // Si es un rango abierto (ej. 5:), podemos guardar un indicador o dejarlo vacío
                $listaEtiq.add("");
            }
            $esRango = true;
        }
    ;

etPP returns [String valor]
    : simpvalue { $valor = $simpvalue.valor; }
    | { $valor = null; }
    ;

listaetiquetas returns [ArrayList<String> listaEtiq]
    : ',' simpvalue resto=listaetiquetas
        {
            $listaEtiq = $resto.listaEtiq;
            $listaEtiq.add(0, $simpvalue.valor);
        }
    |
        {
            // Esta es la forma correcta: la lista nace en la condición de parada vacía
            $listaEtiq = new ArrayList<String>();
        }
    ;

//PARTE LEXICA

//PALABRAS RESERVADAS
PROGRAM : 'PROGRAM';
END : 'END';
INTERFACE : 'INTERFACE';
SUBROUTINE : 'SUBROUTINE';
INTENT : 'INTENT';
FUNCTION : 'FUNCTION';
PARAMETER : 'PARAMETER';
CALL : 'CALL';
INTEGER : 'INTEGER';
REAL : 'REAL';
CHARACTER : 'CHARACTER';
IN : 'IN';
OUT : 'OUT';
INOUT : 'INOUT';

//PALABRAS CONDICIONALES    (PARTE OPCIONAL)
OR: '.OR.';
AND: '.AND.';
EQV: '.EQV.';
NEQV: '.NEQV.';
NOT: '.NOT.';

//OPERADORES LOGICOS
OP_LT : '<';
OP_GT : '>';
OP_LE : '<=';
OP_GE : '>=';
OP_EQ : '==';
OP_NE : '/=';

//PALABRAS SENTENCIAS DE CONTROL
IF: 'IF';
THEN: 'THEN';
ENDIF: 'ENDIF';
ELSE:'ELSE';
DO:'DO';
WHILE:'WHILE';
ENDDO:'ENDDO';
SELECT:'SELECT';
CASE:'CASE';
DEFAULT:'DEFAULT';

//CONSTANTES NUMERICAS
NUM_INT_CONST_B: 'b\''[01]+'\'';  //contantes binarias (parte opcional)
NUM_INT_CONST_O: 'o\''[0-7]+'\''; //constantes octal (parte opcional)
NUM_INT_CONST_H: 'z\''[0-9A-F]+'\'';  //constantes hexadecimal (parte opcional)
NUM_INT_CONST : '-'? [0-9]+; //constantes numericas enteras

//CONSTANTES LOGICAS
TRUE: '.TRUE.';
FALSE: '.FALSE.';

//OTRAS
NUM_REAL_CONST : '-'? [0-9]+ ('.' [0-9]+ )? ([eE] '-'? [0-9]+)?; //constantes numericas reales y/o exponenciales
IDENT: [a-zA-Z] [a-zA-Z0-9_]*;//identificadores
STRING_CONST
    : '\'' ( '\'\'' | ~[\r\n'] )* '\''  // cadenas con '' y admite " dentro
    | '"'  ( '""'   | ~[\r\n"] )* '"'   //cadenas con "" y admite ' dentro
    ;
COMENT : '!' .*? '\r'? '\n' -> skip; //comentarios
WS : [ \t\r\n]+ -> skip; //espacios y saltos de linea


