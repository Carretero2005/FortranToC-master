#define bloque 1024
#define PI 3.141592
#define S "SI"
#define literal1 "comilla doble \" dentro"

void proc1( float *c , int d , int *e );
int fun1( int a , char b[] );

void main ( void ) {
	int contador = 0, control = 2, total = 0, i;
	float resultado = 0.0;
	char b[4] = "hola";
	int d = 5, e = 10;
	resultado = (total+50)/2.0;
	while(contador < 3) {
		contador = contador+1;
		if(contador == 2 && 1) {
		total = total+fun1(d, b);
	} else {
		total = total+10;
	}
	}
	for(i = 1; i <= 5; i = i + 1) {
		total = total+i;
	}
	switch (control) {
		case 1:
			total = total+100;
			break;
		case 2:
		case 3:
		case 4:
			total = total+200;
			break;
		default:
			total = total+500;
	}
}

void proc1( float *c , int d , int *e ) {
	*c = 5.5;
}

int fun1( int a , char b[] ) {
	return a*2;
}
