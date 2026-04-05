program untitled;
type
	celular = record
		cod:integer;
		nombre:string;
		descripcion:string;
		marca:string;
		precio:real;
		stockM:integer;
		stockD:integer;
	end;
	archivo = file of celular;

procedure solicitarNombre(var arch:archivo);
var
	nombre:string;
begin
	writeln('ingrese el nombre del archivo');
	readln(nombre);
	assign(arch,nombre);
end;
procedure crearTxt(var txtCel:text);
begin
	assign(txtCel,'celularesCARGA.txt');
	rewrite(txtCel);

	{ Celular 1 }
	writeln(txtCel, '1 350000 Samsung');
	writeln(txtCel, '2 3 gama_media');
	writeln(txtCel, 'Samsung Galaxy A15');

	{ Celular 2 }
	writeln(txtCel, '2 520000 Motorola');
	writeln(txtCel, '8 2 gama_alta');
	writeln(txtCel, 'Motorola Moto G84');

	{ Celular 3 }
	writeln(txtCel, '3 290000 Xiaomi');
	writeln(txtCel, '15 5 gama_baja');
	writeln(txtCel, 'Xiaomi Redmi 13C');

	{ Celular 4 }
	writeln(txtCel, '4 780000 Apple');
	writeln(txtCel, '4 2 premium');
	writeln(txtCel, 'iPhone 13');

	{ Celular 5 }
	writeln(txtCel, '5 610000 Samsung');
	writeln(txtCel, '6 3 gama_alta');
	writeln(txtCel, 'Samsung Galaxy S21');

	close(txtCel);
end;

procedure crearArchivo(var arch:archivo;var txtCel:text);
var
	cel:celular;
begin
	reset(txtCel);
	solicitarNombre(arch);rewrite(arch);
	while(not eof(txtCel))do
	begin
		readln(txtCel, cel.cod,cel.precio,cel.marca);
		readln(txtCel,cel.stockD, cel.stockM, cel.descripcion);
		readln(txtCel, cel.nombre);
		write(arch,cel);
	end;
	close(txtCel);close(arch);
end;

procedure listarCelular(c:celular);
begin
	writeln('CODIGO : ', c.cod);
	writeln('PRECIO : ', c.precio);
	writeln('MARCA : ',c.marca);
	writeln('STOCK DISPONIBLE : ', c.stockD);
	writeln('STOCK MINIMO : ', c.stockM);
	writeln('DESCRIPCION : ', c.descripcion);
	writeln('NOMBRE : ', c.nombre);
end;

procedure listarStockDeficiente(var arch:archivo);
var
	cel:celular;
begin
	reset(arch);
	while(not eof(arch))do
	begin
		read(arch,cel);
		if(cel.stockD<cel.stockM)then
			listarCelular(cel);
	end;
	close(arch);
end;

procedure listarDescripcion(var arch:archivo);
var
	cel:celular;
	des:string;
begin
	reset(arch);
	writeln('Ingrese la descripcion en la que esta interesado');
	readln(des);
	while(not eof(arch))do
	begin
		read(arch,cel);
		if(pos(des, cel.descripcion) > 0) then
			listarCelular(cel);
	end;
	close(arch);
end;

procedure exportarArchivo(var arch:archivo; var txt:text);
var
	cel:celular;
begin
	assign(txt,'celulares.txt');rewrite(txt);
	reset(arch);
	while(not eof(arch))do
	begin
		read(arch,cel);
		writeln(txt,cel.cod,' ', cel.precio,' ' , cel.marca);
		writeln(txt,cel.stockD,' ',cel.stockM,' ',cel.descripcion);
		writeln(txt,cel.nombre);
	end;
	close(arch);
	close(txt);
end;

function buscarCelular(var arch:archivo;nombre:string;var pos:integer):boolean;
var
	cel:celular;
	encontre:boolean;
begin
	seek(arch,0);
	encontre:=false;
	while((not eof(arch))and(not encontre))do
	begin
		read(arch,cel);
		if(cel.nombre=nombre)then
		begin
			encontre:=true;
			pos:=filePos(arch)-1;
		end;
	end;
	buscarCelular:=encontre;
end;

procedure agregarAlFinal(var arch:archivo);
var
	cel:celular;
	esta:boolean;
	pos:integer;
begin
	reset(arch);
	writeln('Ingrese el nombre del celular que quiera ingresar');
	readln(cel.nombre);
	while(cel.nombre<>'fin')do
	begin
		esta:= buscarCelular(arch,cel.nombre,pos);
		if(not esta)then
		begin
			writeln('COD : ');readln(cel.cod);
			writeln('PRECIO : ');readln(cel.precio);
			writeln('MARCA : ');readln(cel.marca);
			writeln('STOCK DISPONIBLE : ');readln(cel.stockD);
			writeln('STOCK MINIMO : ');readln(cel.stockM);
			writeln('DESCRIPCION : ');readln(cel.descripcion);
			seek(arch,fileSize(arch));
			write(arch,cel);
		end
		else
			writeln('el celular ingresado ya se encuentra registrado');
		writeln('Ingrese el nombre del celular que quiera ingresar');
		readln(cel.nombre);
	end;
	close(arch);
end;

procedure modificarStock(var arch:archivo);
var
	cel:celular;
	pos:integer;
begin
	reset(arch);
	writeln('Ingrese el nombre del celular que quiera cambiar stock');
	readln(cel.nombre);
	if(buscarCelular(arch,cel.nombre,pos))then
	begin
		seek(arch,pos);
		write('ingrese el nuevo stock');
		readln(cel.stockD);
		write(arch,cel);
	end
	else
		writeln('el celular ingresado no existe');
	close(arch);
end;

procedure exportarSinStock (var arch:archivo;var txt:text);
var
	cel:celular;
begin
	assign(txt,'SinStock.txt');rewrite(txt);
	reset(arch);
	while(not eof(arch))do
	begin
		read(arch,cel);
		if(cel.stockD=0)then
		begin
			writeln(txt,cel.cod, ' ', cel.precio, ' ', cel.marca );
			writeln(txt,cel.stockD, ' ', cel.stockM, ' ', cel.descripcion );
			writeln(txt,cel.nombre);
		end;
	end;
end;
var
	arch,arch2:archivo;
	txtSinStock,txtNuevo,txtCel:text;
BEGIN
	crearTxt(txtCel);
	crearArchivo(arch,txtCel);
	//listarStockDeficiente(arch);
	//listarDescripcion(arch);
	//exportarArchivo(arch,txtNuevo);
	agregarAlFinal(arch);
	modificarStock(arch);
	exportarSinStock(arch,txtSinStock);
END.
