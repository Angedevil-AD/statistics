// Variance - StDev - CLT
// M.Aek Progs Angdevil AD
unit Unit1;

interface

uses
  Winapi.Windows,math, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    ListBox2: TListBox;
    Button3: TButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    ComboBox1: TComboBox;
    Edit2: TEdit;
    ListBox3: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    ListBox4: TListBox;
    Button4: TButton;
    Label4: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
Form1: TForm1;
obs: array of double;
N: longint;
mean:double;
Sigma:double;
implementation

{$R *.dfm}




function erfc(const x: Double): Double;
var
  t,z,ans: Double;
begin
  z := abs(x);
  t := 1.0/(1.0+0.5*z);
  ans := t*exp(-z*z-1.26551223+t*(1.00002368+t*(0.37409196+t*(0.09678418+
    t*(-0.18628806+t*(0.27886807+t*(-1.13520398+t*(1.48851587+
    t*(-0.82215223+t*0.17087277)))))))));
  if x>=0.0 then begin
    Result := ans;
  end else begin
    Result := 2.0-ans;
  end;
end;

function erf(const x: Double): Double;
begin
  Result := 1.0-erfc(x);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if radiobutton2.Checked=true then begin
try
listbox1.Items.LoadFromFile('Data.txt');
except
On E:Exception do begin
Messagedlg('Error File I/O',mterror,[mbok],0);
listbox1.Clear;
exit;
end;

end;
end

else begin

if((edit1.Text)=' ') or(strlen(pchar(edit1.Text))=0) then
exit;
listbox1.Items.Add(edit1.Text);
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
I: Integer;
u:double;
VARX:double;
stdev:double;
begin
N:= listbox1.Count;
setlength(obs,N);
u := 0;
varx := 0;
listbox2.Clear;
for I := 0 to N-1 do begin
try
obs[i]:= listbox1.Items[i].ToDouble;

except
on E: exception do begin
N:=0;
Messagedlg('Value '+obs[i].ToString+' not valid',mterror,[mbok],0);
listbox1.Clear;
listbox2.Clear;
exit;
end;
end;

u:= u+obs[i];
end;

//mean
u:= u/N;
if u = 0 then
exit;
listbox2.Items.Add('Mean  = '+u.ToString());
mean := u;
//varx
for I := 0 to N-1 do begin
varx := varx + power((obs[i]-u),2);
end;
varx := varx/N;
if varx = 0 then
exit;
listbox2.Items.Add('Var(X)  = '+varx.ToString());

//stdev
stdev := sqrt(varx);
if stdev = 0 then
exit;
listbox2.Items.Add('StDev  = '+Stdev.ToString());
sigma:=stdev;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
mean := -1;
sigma:=-1;
edit1.Text:='0';
listbox1.Clear;
listbox2.Clear;
end;





procedure TForm1.Button4Click(Sender: TObject);
var
Z:double;
N:longint;
Xi: double;
P:double;
p1,p2:double;
deff:double;
begin
if((edit2.Text)=' ') or(strlen(pchar(edit2.Text))=0) then
exit;
if((edit3.Text)=' ') or(strlen(pchar(edit3.Text))=0) then
exit;

if strtoint(edit2.Text)=0 then
exit;

listbox3.Clear;
listbox4.Clear;

if (mean = -1) or (sigma=-1) then
exit;
N :=strtoint(edit2.Text);
Xi :=strtoint(edit3.Text);

Z := sqrt(N) *((Xi - mean) / sigma);
listbox3.Items.Add('CLT: Z  = '+Z.ToString());


//<
if combobox1.ItemIndex=0 then begin
p := (mean + (Z*sigma));
p := 0.5 * (1 + ( erf( (p-mean)/((sqrt(2))*sigma ))));
listbox4.Items.Add('P  = '+p.ToString());
end;

//>
if combobox1.ItemIndex=1 then begin
p := (mean + (Z*sigma));
p := 1.0 - (0.5 * (1 + ( erf( (p-mean)/((sqrt(2))*sigma )))));
listbox4.Items.Add('P  = '+p.ToString());
end;

//range
if combobox1.ItemIndex=2 then begin
if((edit4.Text)=' ') or(strlen(pchar(edit4.Text))=0) then
exit;
if(strtoint(edit4.Text) <= strtoint(edit3.Text)) then
exit;

//>
Xi :=strtoint(edit3.Text);
Z := sqrt(N) *((Xi - mean) / sigma);
p1 := (mean + (Z*sigma));
p1 :=  1.0 - (0.5 * (1 + ( erf( (p1-mean)/((sqrt(2))*sigma )))));
listbox3.Items.Add('CLT: Z1  = '+Z.ToString());
listbox4.Items.Add('p1  = '+p1.ToString());
//<
Xi :=strtoint(edit4.Text);
Z := sqrt(N) *((Xi - mean) / sigma);
p2 := (mean + (Z*sigma));
p2 := 0.5 * (1 + ( erf( (p2-mean)/((sqrt(2))*sigma ))));
listbox3.Items.Add('CLT: Z2  = '+Z.ToString());
listbox4.Items.Add('p2  = '+p1.ToString());

//deff
deff := p2 - p1;
listbox4.Items.Add('Deff  = '+deff.ToString())
end;




end;

procedure TForm1.ComboBox1Click(Sender: TObject);
begin
if combobox1.ItemIndex=2 then
edit4.Visible:=true
else
edit4.Visible:=false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
mean := -1;
sigma:=-1;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
edit1.Visible := true;
mean := -1;
sigma:=-1;
edit1.Text:='0';
listbox1.Clear;
listbox2.Clear;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
edit1.Visible := false;
mean := -1;
sigma:=-1;
edit1.Text:='0';
listbox1.Clear;
listbox2.Clear;
end;

end.
