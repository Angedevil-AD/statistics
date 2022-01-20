// Expected VALUE
// M.Aek Progs Angedevil AD

program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

var
i,N,input:longint;
x:array of double;
p:array of double;
E: double;
begin

setlength(x,1000);
setlength(p,1000);
writeln('--------Expected Value (M.Aek Progs AD) -------');

i:=0;


while(true) do begin
writeln('input outcome (x):'+i.ToString());
try
readln(x[i]);
except
on E: exception do begin
writeln('Invalid value!!!');
i:=0;
continue;
end;
end;
writeln('input propability (p):'+i.ToString());

try
readln(p[i]);
except
on E: exception do begin
writeln('Invalid value!!!');
i:=0;
continue;
end;
end;



writeln('Calc E[X]: 1       Input Next data: 2 ');
try
readln(input);
except
on E: exception do begin
writeln('Invalid value!!!');
i:=0;
continue;
end;
end;

if(input = 2) then begin
i:= i+1;
continue;
end

else if(input = 1) then begin
N:=i;
E:=0;
for I := 0 to N do begin
E := E + (x[i]*p[i]);
end;
writeln('Expected Value:   E[X]= '+E.ToString());
writeln('');
writeln('');
writeln('');
i:=0;
end

else  begin
i:=0;
E:=0;
N:=0;
end;

end;

end.


