program untitled;

type
	empleado = record
		nro:integer;
		apellido:string;
		nombre:string;
		edad:integer;
		DNI:integer;
	end;
	archivo = file of empleado;

procedure asignarNombre(var arch:archivo);
var
	nombre:String;
begin
	writeln('Ingrese el nombre de el archivo');
	readln(nombre);
	assign(arch,nombre);
end;

procedure listarEmpleado(emp:empleado);
begin
	writeln('LISTO EMPLEADO');
	writeln('NRO : ', emp.nro);
	writeln('NOMBRE : ',emp.nombre);
	writeln('APELLIDO : ',emp.apellido);
	writeln('EDAD : ', emp.edad);
	writeln('DNI : ',emp.dni);
end;	

procedure agregarEmpleados(var arch:archivo);
var
	emp:empleado;
begin
	rewrite(arch);
	writeln('apellido');
	readln(emp.apellido);
	while(emp.apellido<>'fin')do
	begin
		writeln('NRO');
		readln(emp.nro);
		writeln('nombre');
		readln(emp.nombre);
		writeln('EDAD');
		readln(emp.edad);
		writeln('DNI');
		readln(emp.DNI);
		write(arch,emp);
		writeln('apellido');
		readln(emp.apellido);
	end;
	close(arch);
end;
procedure buscarPorNombre(var arch:archivo);
var
	nombre:String;
	emp:empleado;
begin
	writeln('Ingrese el nombre que quiera buscar');
	readln(nombre);
	reset(arch);
	while(not eof(arch))do
	begin
		read(arch,emp);
		if(emp.nombre=nombre)then
			listarEmpleado(emp);
	end;
	close(arch);
end;

procedure buscarPorApellido(var arch:archivo);
var
	apellido:String;
	emp:empleado;
begin
	writeln('Ingrese el apellido que quiera buscar');
	readln(apellido);
	reset(arch);
	while(not eof(arch))do
	begin
		read(arch,emp);
		if(emp.apellido=apellido)then
			listarEmpleado(emp);
	end;
	close(arch);
end;

procedure listarEmpleados(var arch:archivo);
var
	emp:empleado;
begin
	reset(arch);
	while(not eof(arch))do
	begin
		read(arch,emp);
		listarEmpleado(emp);
	end;
end;

procedure listarMayores70(var arch:archivo);
var
	emp:empleado;
begin
	reset(arch);
	while(not eof(arch))do
	begin
		read(arch,emp);
		if(emp.edad>70)then
			listarEmpleado(emp);
	end;
	close(arch);
end;

function getPosicionEmpleado(var arch:archivo; nro:integer): integer;
var
	emp:empleado;
	encontre:boolean;
	pos:integer;
begin
	encontre :=false;
	pos:=-1;
	seek(arch,0);
	while((not eof(arch)) and (not encontre))do
	begin
		read(arch,emp);
		if(emp.nro=nro)then
		begin
			pos:=filePos(arch)-1;
			encontre:=true;
		end;
	end;
	getPosicionEmpleado:=pos;
end;

procedure agregarEmpleadosAlFinal(var arch:archivo);
var
	emp:empleado;
	posicionEmpleado:integer;
begin
	reset(arch);
	writeln('Ingrese el numero de empleado que quiera agregar o -1 para finalizar');
	readln(emp.nro);
	while(emp.nro<>-1)do 
	begin
		posicionEmpleado := getPosicionEmpleado(arch,emp.nro);
		if(posicionEmpleado=-1)then
		begin
			seek(arch,fileSize(arch));
			writeln('APELLIDO');readln(emp.apellido);
			writeln('NOMBRE');readln(emp.nombre);
			writeln('EDAD');readln(emp.edad);
			writeln('DNI');readln(emp.dni);
			write(arch,emp);
		end
		else
			writeln('EL EMPLEADO INGRESADO YA EXISTE');
		writeln('Ingrese el numero de empleado que quiera agregar o -1 para finalizar');
		readln(emp.nro)	
	end;
	close(arch);
end;

procedure modificarEdad(var arch:archivo);
var
	emp:empleado;
	posicionEmpleado:integer;
begin
	reset(arch);
	writeln('INGRESE EL NUMERO DE EMPLEADO QUE QUIERA MODIFICAR LA EDAD');
	readln(emp.nro);
	posicionEmpleado := getPosicionEmpleado(arch,emp.nro);
	if(posicionEmpleado<>-1)then
	begin
		seek(arch,posicionEmpleado);
		read(arch,emp);
		seek(arch,filePos(arch)-1);
		writeln('INGRESE LA EDAD NUEVA');readln(emp.edad);
		write(arch,emp);
	end
	else
		writeln('EL EMPLEADO INGRESADO NO EXISTE');
	close(arch);
end;

procedure escribirTXT(var txt:text;emp:empleado);
begin
	writeln(txt,'NRO : ', emp.nro);
	writeln(txt,'APELLIDO : ', emp.apellido);
	writeln(txt,'NOMBRE ; ', emp.nombre);
	writeln(txt, 'DNI : ', emp.dni);
	writeln(txt, 'EDAD : ',emp.edad);
end;

procedure exportarArchivo(var arch:archivo; var txt:text);
var
	emp:empleado;
begin
	assign(txt,'todos_empleados.txt');
	rewrite(txt);reset(arch);
	while(not eof(arch))do
	begin
		read(arch,emp);
		escribirTXT(txt,emp);
	end;	
	close(arch);
	close(txt);
end;

procedure exportarDNINoCargado(var arch:archivo; var txtFaltaDni:text);
var
	emp:empleado;
begin
	assign(txtFaltaDni,'faltaSNIEmpleado.txt');
	rewrite(txtFaltaDni);reset(arch);
	while(not eof(arch))do
	begin
		read(arch,emp);
		if(emp.dni=00)then
			escribirTXT(txtFaltaDni,emp);
	end;
	close(arch);close(txtFaltaDni);
end;
var
	arch:archivo;
	txt,txtFaltaDni:text;
BEGIN
	asignarNombre(arch);rewrite(arch); 
	agregarEmpleados(arch);
	//buscarPorApellido(arch);
	//buscarPorNombre(arch);
	//writeln('LISTO TODOS LOS EMPLEADOS');
	//listarEmpleados(arch);
	//writeln('LISTO LOS MAYORES DE 70');
	//listarMayores70(arch);
	agregarEmpleadosAlFinal(arch);
	modificarEdad(arch);
	exportarArchivo(arch,txt);
	exportarDNINoCargado(arch,txtFaltaDni);
END.
