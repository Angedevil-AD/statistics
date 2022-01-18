unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    Panel2: TPanel;
    ListBox1: TListBox;
    insert: TButton;
    edit2: TEdit;
    Label1: TLabel;
    Button1: TButton;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure insertClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;



var
Form2: TForm2;
implementation

{$R *.dfm}
uses unit1;


procedure TForm2.Button1Click(Sender: TObject);
var
i,j:longint;
namecmp:string;
tmpcol:tstringlist;
begin
if listbox1.Count = 0 then begin
messagedlg('No data !',mterror,[mbok],0);
exit;
end;

if (edit1.Text) =' ' then begin
messagedlg('No Name !',mterror,[mbok],0);
exit;
end;
if strlen(pchar(edit1.Text)) =0 then begin
messagedlg('No Name !',mterror,[mbok],0);
exit;
end;






//update propa
if form1.rpropa.Checked=true then begin//---------

for I := 0 to classcount-1 do begin
if Eventdata[eventcount].classprov[i] ='' then
exit;
end;

eventcount := eventcount+1;
setlength(Eventdata[eventcount].classprov,classcount+1);
cnt:=cnt+1;
setlength(eventdata,cnt);

form1.stringgrid1.rowcount:=eventcount+1;
for I := 0 to eventcount-1 do begin
form1.stringgrid1.Cells[0,i+1] := Eventdata[i].eventname;
for j := 0 to classcount-1 do begin
form1.stringgrid1.Cells[j+1,i+1] := Eventdata[i].classprov[j];
end;
end;

form1.Panel3.Caption := eventcount.ToString;


end;//---------------------


//update predict
if form1.rpredict.Checked=true then begin//---------


if form1.rclass.Checked=true then begin//---------
if classcount > 0 then
exit;

form1.stringgrid1.rowcount:=listbox1.Count+1;
form1.stringgrid1.colcount:=form1.stringgrid1.colcount+1;

form1.stringgrid1.Cells[shiftsg,0] := classdata.Strings[0];
for I := 0 to listbox1.Count-1 do begin
predictclassdata.Add(listbox1.Items[i]);
form1.stringgrid1.Cells[shiftsg,i+1] := listbox1.Items[i];
end;
shiftsg:=shiftsg+1;
form1.stringgrid1.colcount:=shiftsg;
classcount:=1;
end;//---------------------------


if form1.revent.Checked=true then begin//---------
form1.stringgrid1.rowcount:=listbox1.Count+1;
form1.stringgrid1.colcount:=form1.stringgrid1.colcount+1;

setlength(Eventdata[eventcount].classprov,listbox1.Count);
Eventdata[eventcount].eventname:=edit1.Text;
form1.stringgrid1.Cells[shiftsg,0] := Eventdata[eventcount].eventname;
for I := 0 to listbox1.Count-1 do begin
Eventdata[eventcount].classprov[i] := listbox1.Items[i];
form1.stringgrid1.Cells[shiftsg,i+1] := listbox1.Items[i];
end;

shiftsg:= shiftsg+1;
form1.stringgrid1.colcount:=shiftsg;
//swap class & ev
if classcount > 0 then begin
tmpcol:=tstringlist.Create;
for I := 0 to form1.stringgrid1.RowCount-1 do
tmpcol.Add(form1.stringgrid1.Cells[form1.stringgrid1.colcount-2,i]);

form1.stringgrid1.Cols[form1.stringgrid1.colcount-2] :=form1.stringgrid1.Cols[form1.stringgrid1.colcount-1];
for I := 0 to form1.stringgrid1.RowCount-1 do
form1.stringgrid1.cells[form1.stringgrid1.colcount-1,i]:=tmpcol.Strings[i];

tmpcol.Free;
end;


eventcount := eventcount+1;
cnt:=cnt+1;
setlength(eventdata,cnt);
form1.Panel3.Caption := eventcount.ToString;
listbox1.Clear;
edit1.Clear;
edit2.Clear;
end;//--------

end;//---------------------------








end;

procedure TForm2.Button2Click(Sender: TObject);
var
i,j:longint;
begin

listbox1.Clear;
for I := 0 to eventcount-1 do begin
listbox1.Items.add('Class: '+combobox1.Text+'  EVENT NAME: '+eventdata[i].eventname);
listbox1.Items.add(eventdata[i].classprov[idxx]);
end;


end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
idxx := combobox1.ItemIndex;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
if form1.revent.Checked = true then begin
panel1.Caption := 'Event Name:';
end;
if form1.rclass.Checked = true then begin
panel1.Caption := 'Class Name:';
end;
if form1.rpredict.Checked = true then begin
panel2.Caption := 'Prediction MODE';
end;
if form1.rpropa.Checked = true then begin
panel2.Caption := 'Propability MODE';

listbox1.Clear;
edit1.Clear;
edit2.Clear;
end;


end;

procedure TForm2.FormShow(Sender: TObject);
var
i:integer;
begin
if form1.revent.Checked = true then begin
panel1.Caption := 'Event Name:';
end;
if form1.rclass.Checked = true then begin
panel1.Caption := 'Class Name:';
end;
if form1.rpredict.Checked = true then begin
panel2.Caption := 'Prediction MODE';
end;
if form1.rpropa.Checked = true then begin
panel2.Caption := 'Propability MODE';
end;

combobox1.Clear;
listbox1.Clear;
edit1.Clear;
edit2.Clear;

//ON PROPA
if form1.rpropa.Checked = true then begin   /////////////
combobox1.Visible := true;
button2.Visible:=true;
for I := 0 to classdata.Count-1 do begin
combobox1.Items.Add(classdata.Strings[i]);
end;
combobox1.ItemIndex:=0;
idxx:=0;
setlength(Eventdata[eventcount].classprov,classcount+1);
end; ///////////////////////



//ON Prediction
if form1.rpredict.Checked = true then begin   /////////////
if(shiftsg=0) then begin
form1.stringgrid1.RowCount:=2;
form1.stringgrid1.colcount:=1;
end;
idxx:=0;

if form1.rclass.Checked = true then begin
combobox1.Visible := false;
button2.Visible:=false;
end;

if form1.revent.Checked = true then begin
combobox1.Visible := true;
button2.Visible:=false;
if classcount > 0 then
combobox1.Items.Add(classdata.Strings[0]);
combobox1.ItemIndex:=0;

idxx:=0;
setlength(Eventdata[eventcount].classprov,classcount+1);

end;

end;
///


end;

procedure TForm2.insertClick(Sender: TObject);
begin
if (edit1.Text) =' ' then
exit;
if strlen(pchar(edit1.Text)) =0 then
exit;
if (edit2.Text) =' ' then
exit;
if strlen(pchar(edit2.Text)) =0 then
exit;



//update event data if rpropa mode activ
if Form1.rpropa.Checked = true then begin
listbox1.Clear;
listbox1.Items.Add(edit2.Text);
Eventdata[eventcount].eventname:=edit1.Text;
Eventdata[eventcount].classcount := classcount;
Eventdata[eventcount].classprov[idxx] := edit2.Text;
end;

//update class data if rclass mode activ
if Form1.rpredict.Checked = true then begin       //------
if Form1.rclass.Checked = true then begin
classdata.Clear;
classdata.Add(edit1.Text);

form1.panel2.Caption := '1';
listbox1.Items.Add(edit2.Text);
end;

if Form1.revent.Checked = true then begin
listbox1.Items.Add(edit2.Text);
end;

end;//------------------------------------------

end;

end.
