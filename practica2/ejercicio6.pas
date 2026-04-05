program untitled;
const valorAlto = 9999;
type
	regDet = record
		cod_usuario:integer;
		fecha:string;
		tiempo_sesion:real;
	end;
	
	regMae = record
		cod_usuario:integer;
		fecha:string;
		tiempo_total:real;
	end;
	detalle = file of regDet;
	vec_detalle = array[1..5] of detalle;
	vec_registro = array[1..5] of regDet;
	maestro = file of regMae;


procedure nombrarArchivosDet(var vec_det:vec_detalle);
var
	i:integer;
	num:string;
begin
	for i:= 1 to 5 do
	begin
		str(i,num);
		assign(vec_det[i],'detalle' + num);
	end;
end;

procedure leer(var det:detalle;var dato:regDet);
begin
	if(not eof(det))then
		read(det,dato)
	else
		dato.cod_usuario:=valorAlto;
end;

procedure minimo(var vec_det:vec_detalle;var vec_reg:vec_registro;var min:regDet);
var
	min_i,i:integer;
begin
	min.cod_usuario:=valorAlto;
	for i := 1 to 5 do
	begin
		if(vec_reg[i].cod_usuario<min.cod_usuario)then
		begin	
			min:=vec_reg[i];
			min_i:=i;
		end;
	end;
	if(min.cod_usuario<>valorAlto)then
		leer(vec_det[min_i],vec_reg[min_i]);
end;

procedure crearMaestro(var mae:maestro;var vec_det:vec_detalle;var vec_reg:vec_registro);
var
	act_cod,i:integer;
	regM:regMae;
	min:regDet;
	horas_totales:real;
begin
	for i := 1 to 5 do
	begin
		reset(vec_det[i]);leer(vec_det[i],vec_reg[i])
	end;
	assign(mae,'maestro');rewrite(mae);
	minimo(vec_det,vec_reg,min);
	while(min.cod_usuario<>valorAlto)do
	begin
		act_cod:=min.cod_usuario;
		horas_totales:=0;
		regM.cod_usuario:=min.cod_usuario;
		regM.fecha:=min.fecha;
		while(act_cod=min.cod_usuario)do
		begin
			horas_totales:= horas_totales + min.tiempo_sesion;
			minimo(vec_det,vec_reg,min);
		end;
		regM.tiempo_total:=horas_totales;
		write(mae,regM);
	end;
	close(mae);
	for i:= 1 to 5 do
		close(vec_det[i]);
end;

procedure crearArchivos(var vec_det:vec_detalle;var vec_reg:vec_registro);
var
    i:integer;
    dato:regDet;
    
    procedure escribir(var det:detalle;cod:integer;fec:string;tiempo:real);
    begin
        dato.cod_usuario:=cod;
        dato.fecha:=fec;
        dato.tiempo_sesion:=tiempo;
        write(det,dato);
    end;
    
begin
    // Archivo detalle1
    rewrite(vec_det[1]);
    escribir(vec_det[1],1,'2024-01-01',1.5);
    escribir(vec_det[1],3,'2024-01-02',2.0);
    escribir(vec_det[1],5,'2024-01-03',0.5);

    // Archivo detalle2
    rewrite(vec_det[2]);
    escribir(vec_det[2],2,'2024-01-01',3.0);
    escribir(vec_det[2],4,'2024-01-02',1.0);

    // Archivo detalle3
    rewrite(vec_det[3]);
    escribir(vec_det[3],1,'2024-01-04',2.5);
    escribir(vec_det[3],3,'2024-01-05',1.0);

    // Archivo detalle4
    rewrite(vec_det[4]);
    escribir(vec_det[4],2,'2024-01-03',0.75);
    escribir(vec_det[4],5,'2024-01-04',3.5);

    // Archivo detalle5
    rewrite(vec_det[5]);
    escribir(vec_det[5],4,'2024-01-01',2.0);
    escribir(vec_det[5],6,'2024-01-02',1.25);

    for i:= 1 to 5 do
        close(vec_det[i]);
end;

procedure mostrarMaestro(var mae:maestro);
var
    regM:regMae;
begin
    reset(mae);
    writeln('=== CONTENIDO DEL MAESTRO ===');
    writeln('COD_USUARIO':12, 'FECHA':15, 'TIEMPO_TOTAL':15);
    writeln('--------------------------------------------');
    while(not eof(mae))do
    begin
        read(mae,regM);
        writeln(regM.cod_usuario:12, regM.fecha:15, regM.tiempo_total:15:2);
    end;
    writeln('--------------------------------------------');
    close(mae);
end;

var
	mae:maestro;
	vec_det:vec_detalle;
	vec_reg:vec_registro;
BEGIN
	nombrarArchivosDet(vec_det);
	crearArchivos(vec_det,vec_reg);
	crearMaestro(mae,vec_det,vec_reg);
	mostrarMaestro(mae);
END.
