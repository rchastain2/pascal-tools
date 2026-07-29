unit demo_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, BGRABitmap, BGRABitmapTypes;

type
  { TForm1 }
  TForm1 = class(TForm)
    EraseShadowButton: TButton;
    CropPictureButton: TButton;
    AlphaValueEdit: TSpinEdit;
    procedure EraseShadowButtonClick(Sender: TObject);
    procedure CropPictureButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { private declarations }
    FBitmap: TBGRABitmap;
    function Pixel(const x, y: integer): PBGRAPixel;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.Pixel(const x, y: integer): PBGRAPixel;
begin
  result := FBitmap.Data;
  Inc(result, y * FBitmap.Width + x);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FBitmap := TBGRABitmap.Create('kcalc.png');
end;

procedure TForm1.EraseShadowButtonClick(Sender: TObject);
var
  LData: PBGRAPixel;
  i: integer;
begin
  LData := FBitmap.Data;
  for i := FBitmap.NBPixels - 1 downto 0 do
  begin
    if LData^.alpha < AlphaValueEdit.Value then
      LData^.alpha := 0;
    Inc(LData);
  end;
  Invalidate;
end;

procedure TForm1.CropPictureButtonClick(Sender: TObject);
var
  LRect: TRect;
begin
  LRect := FBitmap.GetImageBounds(cAlpha);
  BGRAReplace(FBitmap, FBitmap.GetPart(LRect));
  Invalidate;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FBitmap.Free;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  FBitmap.Draw(Canvas, 0, 0, FALSE);
end;

end.

