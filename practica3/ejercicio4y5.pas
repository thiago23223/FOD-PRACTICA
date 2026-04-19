program untitled;

type
	reg_flor = record
		nombre:string[45];
		codigo:integer;
	end;
	tArchFlores = file of reg_flor;

procedure agregarFlor(var a:tArchFlores; nombre:string; codigo:integer);
var
	cabecera,flor:reg_flor;
begin
	flor.nombre:=nombre;
	flor.codigo:=codigo;
	reset(a);
	read(a,cabecera);
	if(cabecera.codigo=0)then
	begin
		seek(a,fileSize(a));write(a,flor);
	end
	else
		begin
			seek(a,-(cabecera.codigo));
			read(a,cabecera);
			seek(a,filePos(a)-1);
			write(a,flor);
			seek(a,0);
			write(a,cabecera);
		end;
	writeln('baja exitosa');
	close(a);
end;

procedure eliminarFlor(var a:tArchFlores;nom:string;cod:integer);
var
	reg,cabecera,flor:reg_flor;
begin
	reset(a);
	flor.codigo:=cod;
	reg.nombre:=nom;
	read(a,cabecera);
	read(a,reg);
	while(reg.codigo<>flor.codigo)do
		read(a,reg);
	if(reg.codigo=flor.codigo)then
	begin
		seek(a,filePos(a)-1);
		write(a,cabecera);
		cabecera.codigo:= -(filePos(a)-1); 
		seek(a,0);
		write(a,cabecera);
	end;
	close(a);
end;

var
	arch:tArchFlores;
	codigo:integer;
	nombre:string;
BEGIN
	assign(arch,'archivo_flores');
	writeln('Ingrese nombre y codigo');readln(nombre);readln(codigo);
	agregarFlor(arch,nombre,codigo);
	writeln('Ingrese nombre y codigo');readln(nombre);readln(codigo);
	eliminarFlor(arch,nombre,codigo);
END.
