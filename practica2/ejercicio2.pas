program untitled;
const valorAlto = 9999;
type
	alumno = record
		cod:integer;
		nombre:String;
		apellido:String;
		cantSinFinal:integer;
		cantFinal:integer;
	end;
	materia = record
		cod:integer;
		aprobo:boolean;
	end;
	maestro = file of alumno;
	detalle = file of materia;

procedure crearMaestro(var mae:maestro);
var
    reg:alumno;
begin
    rewrite(mae);
    reg.cod:=1; reg.nombre:='Juan'; reg.apellido:='Perez'; reg.cantFinal:=2; reg.cantSinFinal:=5;
    write(mae,reg);
    reg.cod:=2; reg.nombre:='Maria'; reg.apellido:='Lopez'; reg.cantFinal:=20; reg.cantSinFinal:=3;
    write(mae,reg);
    reg.cod:=3; reg.nombre:='Carlos'; reg.apellido:='Gomez'; reg.cantFinal:=1; reg.cantSinFinal:=4;
    write(mae,reg);
    close(mae);
end;

procedure crearDetalle(var det:detalle);
var
    reg:materia;
begin
    rewrite(det);
    // Materias del alumno cod=1
    reg.cod:=1; reg.aprobo:=true;  write(det,reg);
    reg.cod:=1; reg.aprobo:=true;  write(det,reg);
    reg.cod:=1; reg.aprobo:=false; write(det,reg);
    // Materias del alumno cod=2
    reg.cod:=2; reg.aprobo:=false; write(det,reg);
    reg.cod:=2; reg.aprobo:=true;  write(det,reg);
    // Materias del alumno cod=3
    reg.cod:=3; reg.aprobo:=true;  write(det,reg);
    reg.cod:=3; reg.aprobo:=false; write(det,reg);
    reg.cod:=3; reg.aprobo:=false; write(det,reg);
    close(det);
end;

procedure leer(var det:detalle;var dato:materia);
begin
	if(not eof(det))then
		read(det,dato)
	else
		dato.cod:=valorAlto;
end;

procedure actualizarMaestro(var mae:maestro;var det:detalle);
var
	regM:alumno;regD:materia;
	totalAprobadas,totalNoAprobadas,aux:integer;
begin
	reset(mae);reset(det);
	leer(det,regD);read(mae,regM);
	while(regD.cod <> valorAlto)do
	begin
		aux:=regD.cod;
		totalAprobadas:=0;
		totalNoAprobadas:=0;
		while(regD.cod=aux)do
		begin	
			if(regD.aprobo)then
				totalAprobadas:=totalAprobadas + 1
			else
				totalNoAprobadas:=totalNoAprobadas + 1;
			leer(det,regD);
		end;	
		while( aux <> regM.cod )do
			read(mae,regM);
		regM.cantFinal := regM.cantFinal + totalAprobadas;
		regM.cantSinFinal := (regM.cantSinFinal - totalAprobadas) + totalNoAprobadas;
		seek(mae,filePos(mae)-1);write(mae,regM);
		if(not eof(mae))then
			read(mae,regM);
	end;
	close(mae);close(det);
end;

procedure crearTexto(var mae:maestro;var txt:text);
var
	regM : alumno;
begin
	assign(txt,'masFinales.txt');reset(mae);rewrite(txt);
	while(not eof(mae))do
	begin
		read(mae,regM);
		if(regM.cantFinal>regM.cantSinFinal)then
			writeln(txt,regM.cod,' ',regM.nombre, ' ', regM.apellido,' ',regM.cantFinal,' ',regM.cantSinFinal);
	end;
	close(txt);close(mae);
end;
var
	mae:maestro; det:detalle; txt:text;
BEGIN
	assign(mae,'maestro');assign(det,'detalle');
	crearMaestro(mae);crearDetalle(det);
	actualizarMaestro(mae,det);
	crearTexto(mae,txt);
END.
