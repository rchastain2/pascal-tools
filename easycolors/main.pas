unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btCopy: TButton;
    cbAuto: TCheckBox;
    edColor: TLabeledEdit;
    edCairoColor: TLabeledEdit;
    lbLabel: TLabel;
    lbColors: TListBox;
    procedure btCopyClick(Sender: TObject);
    procedure cbAutoClick(Sender: TObject);
    procedure edColorKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure lbColorsClick(Sender: TObject);
  private
    { private declarations }
    procedure ComputeCairoColor;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  LCLType, ClipBrd, Colors;

type
  TCairoColor = record
    r, g, b: double;
  end;

function GetCairoColor(const AColor: longword): TCairoColor;
begin
  with result do
  begin
    r := (aColor and $FF0000) / $FF0000;
    g := (aColor and $00FF00) / $00FF00;
    b := (aColor and $0000FF) / $0000FF;
  end;
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  LName: TColorName;
begin
  for LName := Low(TColorName) to High(TColorName) do
    lbColors.Items.Append(DATA[LName].name);
  FormatSettings.DecimalSeparator := '.';
end;

procedure TForm1.lbColorsClick(Sender: TObject);
begin
  edColor.Text := '$' + IntToHex(DATA[TColorName(lbColors.ItemIndex)].value, 6);
  ComputeCairoColor;
  edColor.Hint := lbColors.Items[lbColors.ItemIndex];
  edCairoColor.Hint := edColor.Hint;
end;

procedure TForm1.ComputeCairoColor;
const
  D = 3;
var
  LColor: longword;
  LCairoColor: TCairoColor;
begin
  LColor := StrToInt(edColor.Text);
  LCairoColor := GetCairoColor(LColor);

  with LCairoColor do
    edCairoColor.Text := Format('%.*f, %.*f, %.*f', [D, r, D, g, D, b]);

  if cbAuto.Checked then
    BTCopyClick(nil);
end;

procedure TForm1.btCopyClick(Sender: TObject);
begin
  Clipboard.AsText := edCairoColor.Text;
end;

procedure TForm1.cbAutoClick(Sender: TObject);
begin
  btCopy.Enabled := not cbAuto.Checked;
end;

procedure TForm1.edColorKeyPress(Sender: TObject; var Key: char);
begin
  case Key of
    #13: ComputeCairoColor;
    char(VK_Escape): Close;
  end;
end;

end.

