program untitled;
type
	novela = record
		cod:integer;
		nombre:string;
		genero:string;
		precio:real;
	end;
	archivo = file of novela;

procedure crearBinario(var arch:archivo;var txt:text);
var
	nov:novela;
begin
	rewrite(arch);reset(txt);
	while(not eof(txt))do
	begin
		readln(txt,nov.cod,nov.precio,nov.genero);
		readln(txt,nov.genero);
		write(arch,nov);
	end;
	close(txt);close(arch);
end;	

function buscarNovela(var arch:archivo;cod:integer):integer;
var
	nov:novela;
	encontre:boolean;
	pos:integer;
begin
	encontre:=false;
	seek(arch,0);
	pos:=-1;
	while((not eof(arch))and (not encontre))do
	begin
		read(arch,nov);
		if(cod=nov.cod)then
		begin
			encontre:=true;
			pos:=filePos(arch)-1;
		end;
	end;
	buscarNovela:=pos;
end;

procedure agregarNovela(var arch:archivo);
var
	nov:novela;
	pos:integer;
begin
	reset(arch);
	writeln('Ingrese el codigo de novela que quiera agregar');
	readln(nov.cod);
	pos := buscarNovela(arch,nov.cod);
	if(pos=-1)then
	begin
		seek(arch,fileSize(arch));
		writeln('Ingrese el nombre ');readln(nov.nombre);
		writeln('Ingrese el genero ');readln(nov.genero);
		writeln('Ingrese el precio ');readln(nov.precio);
		write(arch,nov)
	end
	else
		writeln('la novela ingresada ya se encuentra registrada');
	close(arch);
end;

procedure modificarNovela(var arch:archivo);
var
	nov:novela;
	posNovela:integer;
	opcion:integer;
begin
	reset(arch);
	writeln('Ingrese el codigo de novela que quiera modificar');
	readln(nov.cod);
	posNovela := buscarNovela(arch,nov.cod);
	if(posNovela<>-1)then
	begin
		seek(arch,posNovela);
		read(arch,nov);
		seek(arch,filePos(arch)-1);
		writeln('ingrese 1 para cambiar titulo, 2 para genero y 3 para precio ');readln(opcion);
		case opcion of
			1 : 
				begin
					writeln('Ingrese el nuevo titulo');readln(nov.nombre);
					write(arch,nov);
				end;
			2 : 
				begin
					writeln('Ingrese el nuevo genero');readln(nov.genero);
					write(arch,nov);
				end;
			3 : 
				begin
					writeln('Ingrese el nuevo precio');readln(nov.precio);
					write(arch,nov)
				end;
	end;
	end
	else
		writeln('La novela ingresada no se encuentra registrada');
	close(arch);
end;

procedure cargarTxt(var txtNov: text);
begin
	assign(txtNov, 'novelasCARGA.txt');
	rewrite(txtNov);

	{ novela 1 }
	writeln(txtNov, '1 1500 drama');
	writeln(txtNov, 'La casa de los espiritus');

	{ novela 2 }
	writeln(txtNov, '2 2000 romance');
	writeln(txtNov, 'Orgullo y prejuicio');

	{ novela 3 }
	writeln(txtNov, '3 1800 fantasia');
	writeln(txtNov, 'El señor de los anillos');

	{ novela 4 }
	writeln(txtNov, '4 1200 misterio');
	writeln(txtNov, 'El codigo da vinci');

	{ novela 5 }
	writeln(txtNov, '5 900 terror');
	writeln(txtNov, 'It');

	close(txtNov);
end;

procedure asignarNombre(var arch:archivo);
var
	nom:string;
begin
	writeln('INGRESE EL NOMBRE DEL ARCHIVO'); readln(nom);
	assign(arch,nom);
end;
var
	arch:archivo;txt:text;
BEGIN
	assign(txt,'novelas.txt');asignarNombre(arch);
	cargarTxt(txt);
	crearBinario(arch,txt);
	agregarNovela(arch);
	modificarNovela(arch);
END.
