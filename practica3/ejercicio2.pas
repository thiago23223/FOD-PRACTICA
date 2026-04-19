program untitled;
const valorAlto = 9999;
type
asistente = record
	nro:integer;
	nomYape:string[30];
	email:string[20];
	telefono:integer;
	dni:integer;
end;
archivo = file of asistente;

procedure leer(var arch:archivo;var reg:asistente);
begin
	if(not eof(arch))then
		read(arch,reg)
	else
		reg.nro:=valorAlto;
end;

procedure bajaLogica(var arch:archivo);
var
	regArch:asistente;
begin
	reset(arch);
	leer(arch,regArch);
	while(regArch.nro<>valorAlto)do
	begin
		if(regArch.nro<1000)then
		begin
			regArch.nomYape := '*' + regArch.nomYape;
			seek(arch,filePos(arch)-1);
			write(arch,regArch);
		end;
		leer(arch,regArch);
	end;
	close(arch);
end;

var
	arch:archivo;
BEGIN
    assign(arch,'archivo_asistente.bi');
    bajaLogica(arch);
END.
