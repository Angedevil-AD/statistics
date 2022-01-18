unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    ListBox1: TListBox;
    Button1: TButton;
    Panel1: TPanel;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
Form3: TForm3;
implementation

{$R *.dfm}
uses unit1;

procedure TForm3.Button1Click(Sender: TObject);

begin
if (edit1.Text) =' ' then
exit;
if strlen(pchar(edit1.Text)) =0 then
exit;

listbox1.Items.Add(edit1.Text);
classcount := classcount +1;
panel1.Caption:='count: '+classcount.ToString;
end;

procedure TForm3.Button2Click(Sender: TObject);
var
i:integer;
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


//update class name
form1.stringgrid1.ColCount:=classcount+1;
for I := 0 to classcount-1 do begin
form1.stringgrid1.Cells[i+1,0] := listbox1.Items[i];
end;

//save to temp
classdata.Clear;
for I := 0 to listbox1.Count-1 do begin
classdata.Add(listbox1.Items[i]);
end;
form1.panel2.Caption := classcount.ToString();


end;

procedure TForm3.FormShow(Sender: TObject);
var
i:integer;
begin
edit1.Clear;
listbox1.Clear;
panel1.Caption:='count: ';

if classcount > 0 then begin
//load class from temp
for I := 0 to classdata.Count-1 do begin
listbox1.Items.Add(classdata.Strings[i]);
end;
panel1.Caption:='count: '+classcount.ToString;
end;

end;

end.
