
program crop;

{$IFDEF FPC}{$MODE objfpc}{$H+}{$ENDIF}
{$IFDEF mswindows}{$APPTYPE console}{$ENDIF}

uses
{$IFDEF FPC}{$IFDEF unix}
  cthreads,
  cwstring,
{$ENDIF}{$ENDIF}
  sysutils,
  classes,
  BGRABitmap,
  BGRABitmapTypes;

(*
function Pixel(const x, y: integer): PBGRAPixel;
begin
  result := LBitmap.Data;
  Inc(result, y * LBitmap.Width + x);
end;
*)

const
  CThreshold = 162;

var
  LBitmap: TBGRABitmap;
  LData: PBGRAPixel;
  LRect: TRect;
  LIndex: integer;
  LFileName: TFilename;

  {.$R *.res}

begin
  WriteLn('Screenshot Cropper');

  if (ParamCount < 1)
    or (not FileExists(ParamStr(1))) then
  begin
    WriteLn(
      'Missing or invalid parameter', LineEnding,
      'Usage :', LineEnding,
      '  crop IMAGE'
      );
    Exit;
  end;

  LFileName := ParamStr(1);
  LBitmap := TBGRABitmap.Create(LFileName);

  WriteLn('File         : ', LFileName);
  WriteLn(Format('Original size: %dx%d', [LBitmap.Width, LBitmap.Height]));

  (* Effacer l'ombre *)
  LData := LBitmap.Data;
  for LIndex := LBitmap.NBPixels - 1 downto 0 do
  begin
    if LData^.alpha < CThreshold then
      LData^.alpha := 0;
    Inc(LData);
  end;

  (* Enlever la partie transparente *)
  LRect := LBitmap.GetImageBounds(cAlpha);
  BGRAReplace(LBitmap, LBitmap.GetPart(LRect));

  LBitmap.SaveToFile(LFileName);

  WriteLn(Format('Final size   : %dx%d', [LBitmap.Width, LBitmap.Height]));

  LBitmap.Free;
end.
