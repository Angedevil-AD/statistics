//-----------------------------------------------
//              Bayes theorem
//         M.Aek progs Angedevil AD
//--------------------------------------------------
unit Unit1;

interface

uses
  Winapi.Windows,math,Clipbrd, Winapi.Messages,unit2,unit3,unit4, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    rpropa: TRadioButton;
    rpredict: TRadioButton;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Button1: TButton;
    Panel1: TPanel;
    revent: TRadioButton;
    rclass: TRadioButton;
    StringGrid1: TStringGrid;
    Button2: TButton;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Button3: TButton;
    ListBox1: TListBox;
    Button4: TButton;
    Button5: TButton;
    Label3: TLabel;
    Timer1: TTimer;
    Label4: TLabel;
    BalloonHint1: TBalloonHint;
    procedure rpredictClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
    procedure rpropaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure reventClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

type
EV=record
eventname:string;
classprov:array of string;
classcount:longint;

end;

type
PPCLASS=record
Pclass: array of double;
name:string;
propa:double;
end;

var
Form1: TForm1;
Eventcount:longint;
classcount:longint;
classdata: tstringlist;
predictclassdata: tstringlist;
eventdata: array of EV;
param: array of double;
pclass: array of ppclass;
redClass: array of string;
redclasscount:longint;
cnt:longint;
idxx:longint;
shiftsg:longint;
isparam:longint;


implementation

{$R *.dfm}



procedure TForm1.Button1Click(Sender: TObject);
begin
form2.ShowModal;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
form3.Show;
end;





//-----------------------------------------------------
//                    BAYES PROPA
//-----------------------------------------------------
function Process_Bayes_propa():integer;
var
I,j: Integer;
pevent_count:double;
total_pevent:double;
Pevent: array of double;
Pevent_total: array of double;
maxx:double;
ind:longint;
begin
pevent_count :=0;
total_pevent := 0;
setlength(pevent,eventcount);
setlength(pevent_total,eventcount);

//Calc all P(event)
for I := 0 to eventcount-1 do begin
pevent_count := 0;
for j := 0 to classcount-1 do begin
pevent_count := pevent_count +strtofloat(eventdata[i].classprov[j]);
end;
//assign
pevent[i] := pevent_count;
pevent_total[i] := pevent_count;
total_pevent := total_pevent+pevent_count; //
end;
//
for I := 0 to eventcount-1 do begin
if  (pevent[i]<> 0) and (total_pevent<>0) then
pevent[i] := pevent[i] /total_pevent
else
pevent[i] :=0;
end;

//show
for I := 0 to eventcount-1 do begin
form1.listbox1.Items.add('P(EV'+i.ToString+') = '+ pevent[i].ToString());
end;







//Calc all P(CLASS | event)
setlength(pclass,classcount);
for I := 0 to classcount-1 do begin
setlength(pclass[i].Pclass,eventcount);
end;

for I := 0 to eventcount-1 do begin
for j := 0 to classcount-1 do begin
pclass[j].Pclass[i] := strtofloat(eventdata[i].classprov[j] )/ pevent_total[i];
pclass[j].name := classdata.Strings[j];
end;
end;


//show
for I := 0 to eventcount-1 do begin
for j := 0 to classcount-1 do begin
form1.listbox1.Items.add('P(CLASS:'+pclass[j].name+'|EVENT:'+i.ToString+') = '+ pclass[j].Pclass[i].ToString());
end;
end;


//caclc P(CLASS)
for j := 0 to classcount-1 do begin
pclass[j].propa := 0;
for I := 0 to eventcount-1 do begin
pclass[j].propa := pclass[j].propa + (pclass[j].Pclass[i] * pevent[i]);
end;
end;

for j := 0 to classcount-1 do begin
form1.listbox1.Items.add('P(CLASS:'+pclass[j].name+') = '+ pclass[j].propa.ToString());
end;

//get dominator
maxx := -1000000000000000;
for j := 0 to classcount-1 do begin
if pclass[j].propa > maxx then  begin
maxx := pclass[j].propa;
ind := j;
end;
end;

form1.listbox1.Items.add('Dominator = CLASS:'+pclass[ind].name+' ... with propability = '+
 format('%.6f',[maxx])+' ( '+format('%d',[round(maxx*100)]) +'% )');


end;










//-----------------------------------------------------
//                    BAYES PREDICT
//-----------------------------------------------------
function Process_Bayes_predict():integer;
var
found,i,indx,j,k,sgm,ffff:longint;
feventclass:array of double;
temp:array of double;
propaclass:array of double;
pclassparam:array of double;
meancnt,tmpcnt:longint;
mean,sigma:double;
maxx:double;
begin


form1.listbox1.items.Add('Param:');
for i:=0 to eventcount-1 do begin
form1.listbox1.items.Add('Event:'+eventdata[i].eventname+' = '+param[i].ToString());
end;



//parse CLASS
setlength(redclass,predictclassdata.Count);
redclasscount:=0;
found:=0;
for i:=0 to predictclassdata.Count-1 do begin
found:=0;
for j:=0 to predictclassdata.Count-1 do begin
if (comparetext(predictclassdata.Strings[i] , redclass[j])=0)  then
found:=1;
end;
if found<>1 then begin
redclass[redclasscount] := predictclassdata.Strings[i];
redclasscount := redclasscount+1;
end;
end;




setlength(redclass,redclasscount);
setlength(propaclass,redclasscount);
setlength(pclassparam,redclasscount);
setlength(feventclass,eventcount);
for i:=0 to redclasscount-1 do begin
pclassparam[i]:=0;
end;


//
for i:=0 to redclasscount-1 do begin
sgm:=0;
for j:=0 to predictclassdata.Count-1 do begin
if (comparetext(predictclassdata.Strings[j] , redclass[i])=0)  then
sgm:=sgm+1;
end;
propaclass[i] := sgm / predictclassdata.Count;
//form1.listbox1.items.Add('propaclass '+propaclass[i].ToString());
end;



setlength(temp,predictclassdata.Count);
for i:=0 to redclasscount-1 do begin
form1.listbox1.items.Add('CLASS '+i.ToString()+': '+redclass[i]);
end;


//calc Propability density function
//for all class
for j := 0 to redclasscount-1 do begin
for k := 0 to eventcount-1 do begin
mean:=0;
sigma:=0;
tmpcnt:=0;
meancnt:=0;
for I := 0 to predictclassdata.Count-1 do begin//////////////////////
if redclass[j] = predictclassdata[i]  then begin //same class
mean := mean +strtofloat(Eventdata[k].classprov[i]);
temp[tmpcnt] :=strtofloat(Eventdata[k].classprov[i]);
tmpcnt:= tmpcnt+1;
meancnt:=meancnt+1;
end;

end;

//alc mean
if mean  <> 0 then
mean := mean / meancnt;
//calc sigma
if mean  <> 0 then begin
for sgm := 0 to tmpcnt-1 do
sigma := sigma + (temp[sgm]-mean)*(temp[sgm]-mean);
end;
if sigma  <> 0 then
sigma := sqrt(sigma / (tmpcnt-1));


//form1.listbox1.items.Add('mean: '+mean.ToString());
//form1.listbox1.items.Add('sigma: '+sigma.ToString());
//updaate feventclass
if(sigma<>0) and ((param[k]-mean)  <>0) then begin
feventclass[k] := (1 / (  Sigma*(sqrt(2*PI)))) * exp(-( 0.5*( ((param[k]-mean)/sigma)*((param[k]-mean)/sigma)  )  ));
//form1.listbox1.items.Add('fx: '+feventclass[k].ToString());
end
else begin //use laplace coreection
feventclass[k] := (1 / 2) * exp(-(param[k]-mean));
end;

//calc Pclassparam
pclassparam[j] := pclassparam[j]+(propaclass[j] * feventclass[k] );
end; //end event
form1.listbox1.items.Add('Propability of class ('+redclass[j]+'): '+pclassparam[j].ToString());

end; //////////////////////////////////////////////////

maxx:=-1000000000000000000;
for j := 0 to redclasscount-1 do begin
if pclassparam[j] > maxx then begin
maxx := pclassparam[j];
indx := j;
end;
end;

form1.listbox1.items.Add('Param classified into  ('+redclass[indx]+')');


end;










procedure TForm1.Button3Click(Sender: TObject);
begin
listbox1.Clear;
if (eventcount=0) then
exit;




if rpropa.Checked = true then begin
if(classcount=0) or(eventcount<2) then begin
messagedlg('error: invalid data !!!',mterror,[mbok],0);
exit;
end;
Process_Bayes_propa();
end;

if rpredict.Checked = true then begin
if isparam <> 99 then begin
exit;
end;
if(classcount=0) or(eventcount<2) then begin
messagedlg('error: invalid data !!!',mterror,[mbok],0);
exit;
end;
Process_Bayes_predict();
end;





end;





procedure TForm1.Button4Click(Sender: TObject);
var i:integer;
begin
rpropa.Checked:=true;
cnt:=2;
shiftsg :=0;
Eventcount := 0;
classcount :=0;
revent.Checked := true;
rclass.Visible:=false;
button2.Visible := true;
classdata.Clear;
predictclassdata.Clear;
listbox1.Clear;
panel2.Caption:='0';
panel3.Caption:='0';
isparam:=0;


for I := 0 to stringgrid1.ColCount-1 do
stringgrid1.Cols[i].Clear;
stringgrid1.RowCount:=2;
stringgrid1.colcount:=2;

setlength(eventdata,2);


end;

procedure TForm1.Button5Click(Sender: TObject);
begin
if (eventcount=0) then
exit;
form4.Show;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
classdata.Free;
predictclassdata.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
shiftsg:=0;
Eventcount := 0;
classcount :=0;
button2.Visible := false;
classdata:= tstringlist.Create;
predictclassdata:= tstringlist.Create;
cnt := 2;
setlength(eventdata,2);
end;

procedure TForm1.GroupBox2Click(Sender: TObject);
begin
Eventcount := 0;
classcount :=0;
end;

procedure TForm1.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
ipos:longint;
begin

if button = mbRight then begin
ipos :=listbox1.ItemAtPos(point(x,y),true);
if ipos <> -1 then begin
clipboard.Clear;
clipboard.AsText := listbox1.Items[ipos];
balloonhint1.Title:= 'user';
balloonhint1.Description:= 'Copy to Clipboard';
balloonhint1.ShowHint(point(form1.Left+listbox1.Left+x,form1.top+listbox1.top+y));
balloonhint1.HideAfter:=2000;
end;
end;

end;

procedure TForm1.reventClick(Sender: TObject);
begin
if rpropa.Checked = true then begin
if classcount = 0 then begin
exit;
end;
end;
end;

procedure TForm1.rpredictClick(Sender: TObject);
var
i:integer;
begin
cnt := 2;
shiftsg :=0;
classdata.Clear;
predictclassdata.Clear;
Eventcount := 0;
classcount :=0;
revent.Checked := true;
rclass.Visible:=true;
button2.Visible := false;
for I := 0 to stringgrid1.ColCount-1 do
stringgrid1.Cols[i].Clear;
listbox1.Clear;
stringgrid1.RowCount:=2;
stringgrid1.colcount:=1;
panel2.Caption:='0';
panel3.Caption:='0';

end;

procedure TForm1.rpropaClick(Sender: TObject);
var
i:longint;
begin
cnt:=2;
shiftsg :=0;
Eventcount := 0;
classcount :=0;
revent.Checked := true;
rclass.Visible:=false;
button2.Visible := true;
classdata.Clear;
predictclassdata.Clear;
listbox1.Clear;
panel2.Caption:='0';
panel3.Caption:='0';


for I := 0 to stringgrid1.ColCount-1 do
stringgrid1.Cols[i].Clear;
stringgrid1.RowCount:=2;
stringgrid1.colcount:=2;
end;





procedure TForm1.Timer1Timer(Sender: TObject);
begin
randomize;
LABEL3.Font.Color := randomrange(0,$FFFF00);
end;


end.
