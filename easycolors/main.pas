unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btCopyColorCairo: TButton;
    btCopyColorAGG: TButton;
    edColorHexa: TLabeledEdit;
    edColorCairo: TLabeledEdit;
    edColorAGG: TLabeledEdit;
    lbLabel: TLabel;
    lbColors: TListBox;
    procedure btCopyColorAGGClick(Sender: TObject);
    procedure btCopyColorCairoClick(Sender: TObject);
    procedure edColorHexaKeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
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
{ Load color names }
  for LName := Low(TColorName) to High(TColorName) do
    lbColors.Items.Append(DATA[LName].name);

  FormatSettings.DecimalSeparator := '.';
end;

procedure TForm1.lbColorsClick(Sender: TObject);
var
  LHexStr: string;
begin
{ Hexadecimal notation }
  LHexStr := IntToHex(DATA[TColorName(lbColors.ItemIndex)].value, 6);
  edColorHexa.Text := '$' + LHexStr;
{ Cairo format }
  ComputeCairoColor;
{ AGG format }
  edColorAGG.Text := Format('$%s, $%s, $%s', [Copy(LHexStr, 1, 2), Copy(LHexStr, 3, 2), Copy(LHexStr, 5, 2)]);
end;

procedure TForm1.ComputeCairoColor;
const
  D = 3;
var
  LColor: longword;
  LCairoColor: TCairoColor;
begin
  LColor := StrToInt(edColorHexa.Text);
  LCairoColor := GetCairoColor(LColor);

  with LCairoColor do
    edColorCairo.Text := Format('%.*f, %.*f, %.*f', [D, r, D, g, D, b]);
end;

procedure TForm1.btCopyColorCairoClick(Sender: TObject);
begin
  Clipboard.AsText := edColorCairo.Text;
end;

procedure TForm1.btCopyColorAGGClick(Sender: TObject);
begin
  Clipboard.AsText := edColorAGG.Text;
end;

procedure TForm1.edColorHexaKeyPress(Sender: TObject; var Key: char);
var
  LHexStr: string;
begin
  case Key of
    #13:
    begin
      { Cairo format }
        ComputeCairoColor;
      { AGG format }
        LHexStr := Copy(edColorHexa.Text, 2, 6);
        edColorAGG.Text := Format('$%s, $%s, $%s', [Copy(LHexStr, 1, 2), Copy(LHexStr, 3, 2), Copy(LHexStr, 5, 2)]);
    end;
    char(VK_Escape): Close;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  lbColors.Anchors := [akTop, akLeft, akRight, akBottom];
  edColorHexa.Anchors := [akLeft, akRight, akBottom];
  edColorCairo.Anchors := [akLeft, akRight, akBottom];
  edColorAGG.Anchors := [akLeft, akRight, akBottom];
  btCopyColorCairo.Anchors := [akRight, akBottom];
  btCopyColorAGG.Anchors := [akRight, akBottom];
  Constraints.MinWidth := Width;
  Constraints.MinHeight := Height;
end;

end.

