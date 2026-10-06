void main ( void ) {
	int opcion = 3, puntuacion = 0;
	switch (opcion) {
		case 1:
			puntuacion = 10;
			break;
		case 2:
		case 3:
		case 4:
			puntuacion = 50;
			break;
		case 5 to 10:
			puntuacion = 100;
			break;
		case < 0:
			puntuacion = -1;
			break;
		default:
			puntuacion = 0;
	}
}
