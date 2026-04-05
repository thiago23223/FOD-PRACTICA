program untitled;
type
	empleado = record
		cod:integer;
		nombre:string;
		monto:real;
	end;
	archivo = file of empleado;



procedure compactar(var arch:archivo;var arch2:archivo);
var
	aux,emp:empleado;
begin
	reset(arch);
	rewrite(arch2);
	while(not eof(arch))do
	begin
		read(arch,emp);
		aux.cod:=emp.cod;aux.monto:=0;aux.nombre:=emp.nombre;
		while((aux.cod=emp.cod)and (not eof(arch)))do
		begin
			aux.monto:=aux.monto + emp.monto;
			read(arch,emp);
		end;
		if (aux.cod = emp.cod) then
			aux.monto := aux.monto + emp.monto
		else 
			if not eof(arch) then
				seek(arch, filePos(arch) - 1);
		write(arch2,aux);
	end;
	close(arch);close(arch2);
end;
var
	arch:archivo;arch2:archivo;
BEGIN
	assign(arch,'archivo1');assign(arch2,'archivo compacto');
	rewrite(arch);close(arch);
	compactar(arch,arch2);
	
END.

