program untitled;
const valorAlto = 9999;
type
	producto = record
		cod:integer;
		nom:string;
		des:string;
		stD:integer;
		stM:integer;
		pre:real;
	end;
	maestro = file of producto;
	sucursal = record
		cod:integer;
		can:integer;
	end;
	detalle = file of sucursal;
	vec_detalle = array[1..30] of detalle;
	vec_registro = array[1..30] of sucursal;

procedure leer(var det:detalle;var dato:sucursal);
begin
	if(not eof(det))then
		read(det,dato)
	else
		dato.cod:=valorAlto;
end;


procedure minimo(var vec_det:vec_detalle;var vec_reg:vec_registro;var min:sucursal);
var
	i,min_i:integer;
begin
	min.cod:=valorAlto;
	for i:= 1 to 30 do
	begin
		if(vec_reg[i].cod<min.cod)then
		begin
			min_i:=i;min:=vec_reg[i];
		end;
	end;
	if(min.cod<>valorAlto)then
		leer(vec_det[min_i],vec_reg[min_i])
end;

procedure actualizarMaestro(var mae:maestro;var vec_det:vec_detalle;var txt:text);
var
	cod_act,cant_ventas,i:integer;
	vec_reg:vec_registro;regMae:producto;
	min:sucursal;
begin
	reset(mae);rewrite(txt);
	for i := 1 to 30
	do begin
		reset(vec_det[i]);leer(vec_det[i],vec_reg[i]);
	end;
	read(mae,regMae);minimo(vec_det,vec_reg,min);
	while(min.cod<>valorAlto)do
	begin
		cod_act:=min.cod;cant_ventas:=0;
		while((min.cod<>valorAlto)and(min.cod=cod_act))do
		begin
			cant_ventas:=cant_ventas + min.can;
			minimo(vec_det,vec_reg,min)
		end;
		while(regMae.cod<>cod_act)do
			read(mae,regMae);
		regMae.stD:=regMae.stD - cant_ventas;
		seek(mae,filePos(mae)-1);write(mae,regMae);
		if(not eof(mae))then read(mae,regMae);
	end;
	close(mae);for i := 1 to 30 do close(vec_det[i]);
end;
procedure crearMaestro(var mae:maestro);
var
    reg:producto;
begin
    rewrite(mae);
    reg.cod:=1; reg.nom:='Coca Cola'; reg.des:='Bebida'; reg.stD:=100; reg.stM:=200; reg.pre:=1.50;
    write(mae,reg);
    reg.cod:=2; reg.nom:='Pepsi'; reg.des:='Bebida'; reg.stD:=80; reg.stM:=150; reg.pre:=1.30;
    write(mae,reg);
    reg.cod:=3; reg.nom:='Sprite'; reg.des:='Bebida'; reg.stD:=60; reg.stM:=100; reg.pre:=1.20;
    write(mae,reg);
    close(mae);
end;

procedure crearDetalle(var vec_det:vec_detalle);
var
    reg:sucursal;
    i:integer;
    num,nombre:string;
begin
    // Sucursal 1: vendió productos 1 y 3
    assign(vec_det[1],'detalle1');
    rewrite(vec_det[1]);
    reg.cod:=1; reg.can:=10; write(vec_det[1],reg);
    reg.cod:=3; reg.can:=5;  write(vec_det[1],reg);
    close(vec_det[1]);

    // Sucursal 2: vendió productos 1 y 2
    assign(vec_det[2],'detalle2');
    rewrite(vec_det[2]);
    reg.cod:=1; reg.can:=20; write(vec_det[2],reg);
    reg.cod:=2; reg.can:=15; write(vec_det[2],reg);
    close(vec_det[2]);

    // Sucursal 3: vendió producto 2
    assign(vec_det[3],'detalle3');
    rewrite(vec_det[3]);
    reg.cod:=2; reg.can:=8; write(vec_det[3],reg);
    close(vec_det[3]);

    // Sucursales 4 a 30: vacías
    for i := 4 to 30 do
    begin
		str(i, num);
		nombre := 'detalle' + num;
		assign(vec_det[i], nombre);
        rewrite(vec_det[i]);
        close(vec_det[i]);
    end;
end;

var
	mae:maestro;det:detalle;txt:text;
	vec_det:vec_detalle;
BEGIN
	assign(mae,'maestro');assign(det,'detalle');assign(txt,'.txt');
	crearMaestro(mae);crearDetalle(vec_det);
	actualizarMaestro(mae,vec_det,txt);
	
END.
