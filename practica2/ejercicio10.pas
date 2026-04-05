program untitled;
const valorAlto = 9999;
type
	empleado = record
		dep:integer;
		divi:integer;
		nro:integer;
		cat:integer;
		cant:real;
	end;
	archivo = file of empleado;
	vec_valor_hora = array[1..15] of real;

procedure cargarArreglo(var txt:text; var vec:vec_valor_hora);
var
	cat:integer;
	valor:real;
begin
	reset(txt);
	while(not eof(txt))do
	begin
		readln(txt,cat,valor);
		vec[cat]:=valor;
	end;
	close(txt);
end;

procedure leer(var arch:archivo; var e:empleado);
begin
	if(not eof(arch))then
		read(arch,e)
	else
		e.dep:=valorAlto;
end;

procedure mostrarArchivo(var arch:archivo;vec:vec_valor_hora);
var
	depAct,diviAct,empAct:integer;
	horas_dep,monto_dep,horas_divi,monto_divi,monto_emp,horas_emp:real;
	regM:empleado;
begin
	reset(arch);
	leer(arch,regM);
	while(regM.dep<>valorAlto)do
	begin
		depAct:=regM.dep;
		horas_dep:=0;
		monto_dep:=0;
		writeln('DEPARTAMENTO : ', depAct);
		while(regM.dep=depAct)do
		begin
			diviAct:=regM.divi;
			writeln('DIVISION : ', diviAct);
			horas_divi:=0;
			monto_divi:=0;
			while((regM.dep=depAct) and (diviAct=regM.divi))do
			begin
				empAct:=regM.nro;
				writeln('EMPLEADO : ', empAct);
				horas_emp:=regM.cant;
				monto_emp:= (vec[regM.cat]*horas_emp);
				writeln('total de horas : ', horas_emp);
				writeln('importe a cobrar :', monto_emp);
				horas_divi:= horas_divi + horas_emp;
				monto_divi:= monto_divi + monto_emp;
				leer(arch,regM);
			end;
			writeln('TOTAL DE HORAS DIVISION : ', horas_divi);
			writeln('MONTO TOTAL POR DIVISION : ', monto_divi);
			horas_dep:=horas_dep + horas_divi;
			monto_dep:=monto_dep + monto_divi; 
		end;
		writeln('TOTAL HORAS DEPARTAMENTO : ', horas_dep );
		writeln('MONTO TOTAL DEPARTAMENTO :', monto_dep);
	end;
	close(arch);
end;

procedure armarArchivos(var txt:text; var arch:archivo);
var
    e:empleado;

    procedure escribirEmp(dep,divi,nro,cat:integer;cant:real);
    begin
        e.dep:=dep; e.divi:=divi; e.nro:=nro;
        e.cat:=cat; e.cant:=cant;
        write(arch,e);
    end;

begin
    // Archivo de texto: categoria y valor hora
    assign(txt,'valores.txt');
    rewrite(txt);
    writeln(txt,'1 10.0');
    writeln(txt,'2 15.0');
    writeln(txt,'3 20.0');
    close(txt);

    // Archivo binario de empleados (ordenado por dep, divi, nro)
    assign(arch,'empleados.dat');
    rewrite(arch);

    // Departamento 1
    //   Division 1
    escribirEmp(1,1,101,1,8.0);
    escribirEmp(1,1,102,2,6.5);
    //   Division 2
    escribirEmp(1,2,201,3,7.0);

    // Departamento 2
    //   Division 1
    escribirEmp(2,1,101,2,9.0);
    escribirEmp(2,1,102,1,4.0);
    //   Division 2
    escribirEmp(2,2,201,3,5.5);
    escribirEmp(2,2,202,2,8.0);

    close(arch);
end;

var
	arch:archivo;
	txt:text;
	vec:vec_valor_hora;
BEGIN
	armarArchivos(txt,arch);
	cargarArreglo(txt,vec);
	mostrarArchivo(arch,vec);
END.
