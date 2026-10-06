void main ( void ) {
	int flag = 1, contador = 0, total = 0, i;
	if(flag == 1 && contador < total) {
		total = total+100;
	} else {
		total = 0;
	}
	while(contador < 3) {
		contador = contador+1;
	}
	for(i = 1; i <= 10; i = i + 2) {
		total = total+i;
	}
}
