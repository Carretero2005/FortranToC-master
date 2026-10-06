void CalcularTodo( int a , int *b , float *c );
float Multiplicar( float x , float y );

void main ( void ) {
	int n1 = 5, n2 = 10;
	float res_out, res_fun;
	CalcularTodo(n1, &n2, &res_out);
	res_fun = Multiplicar(res_out, 2.0);
}

void CalcularTodo( int a , int *b , float *c ) {
	int calculo_interno;
	*b = *b+a;
	*c = 5.5;
}

float Multiplicar( float x , float y ) {
	return x*y;
}
