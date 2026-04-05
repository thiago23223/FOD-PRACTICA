program untitled;
type
	archivo = file of integer;  
var
	archivo_logico: archivo;
	nombreArch:string;
	num: integer;
procedure solicitarNombre(var arch: archivo);
begin
	writeln('Ingrese el nombre del archivo');
	readln(nombreArch);
	assign(arch,nombreArch);
end;

procedure agregarNumero (num:integer;var arch:archivo);
begin
	write(arch,num);
end;
procedure ej2 (var arch:archivo);
var
	valor,cantMenores,cantNumeros,suma:integer;
begin
	cantMenores := 0;
	suma := 0;
	cantNumeros := 0;
	reset(arch);
	while(not eof(arch))do
	begin
		read(arch,valor);
		suma := suma + valor;
		cantNumeros := cantNumeros + 1;
		if(valor<1500)then
			cantMenores := cantMenores + 1;
		writeln('el valor es : ', valor);
	end;
	close(arch);
end;
BEGIN
	solicitarNombre(archivo_logico);
	rewrite(archivo_logico);
	writeln('Ingrese un numero');
	read(num);
	while( num<>30000 )do
	begin
		agregarNumero(num,archivo_logico);
		writeln('Ingrese un numero');
		read(num);
	end;
	close(archivo_logico);
	ej2(archivo_logico);
END.
