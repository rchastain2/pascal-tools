
{
  http://tothpaul.free.fr/sources.php?tools.bmp2ico
}

program BMP2ICO;

{ (c) 2001 by Paul TOTH <tothpaul@free.fr>
  http://tothpaul.free.fr

1-  run this program to associate .BMP to "As Icon" and .ICO to "As Bitmap" options

2- right-click on a 32x32x16 Bitmap to create an Icon with the "As Icon" menu option
   right-click on an Icon to convert it to BMP with the "As Bitmap" (or Open) menu option
}

uses
  Classes;

(* -------------------------------------------------------------------------- *)

type
  TBitmapFileHeader = packed record
    bfType: word;
    bfSize: dword;
    bfReserved1: word;
    bfReserved2: word;
    bfOffBits: dword;
  end;

  TBitmapInfoHeader = packed record
    biSize: dword;
    biWidth: longint;
    biHeight: longint;
    biPlanes: word;
    biBitCount: word;
    biCompression: dword;
    biSizeImage: dword;
    biXPelsPerMeter: longint;
    biYPelsPerMeter: longint;
    biClrUsed: dword;
    biClrImportant: dword;
  end;

  TRGBQuad = packed record
    rgbBlue: byte;
    rgbGreen: byte;
    rgbRed: byte;
    rgbReserved: byte;
  end;

  TBitmapInfo = packed record
    bmiHeader: TBitmapInfoHeader;
    bmiColors: array[0..0] of TRGBQuad;
  end;

  (* -------------------------------------------------------------------------- *)

function ChangeFileExt(s, e: string): string;
begin
  result := Copy(s, 1, Length(s) - 3) + e;
end;

var
  src, dst: TFileStream;

procedure Error(msg: string);
begin
  WriteLn(msg);
  src.free;
  Halt;
end;

var
  BMP: packed record
    Header: TBitmapFileHeader;
    Info: TBitmapInfo;
    RGBA: array[1..15] of integer;
  end;

  ICO: packed record
    // ICONDIR
    idReserved: word; // 0
    idType: word; // 1
    idCount: word; // ho many images
    // ICONDIRENTRY
    bWidth: byte; // 32
    bHeight: byte; // 32
    bColorCount: byte; // 16
    bReserved: byte; // 0
    wPlanes: word; // 0
    wBitCount: word; // 0
    dwBytesInRes: integer; // $2E8 = 744
    dwImageOffset: integer; // $16  = 22
  end;

  icXOR: array[0..31, 0..15] of byte; // 32x32 16 colors bitmap
  icAND: array[0..31, 0..3] of byte; // 32x32 monochrome bitmap

procedure BMPToICO(FileName: string);
var
  x, y, z: integer;
  t, b, m: byte;
begin
  src.ReadBuffer(BMP, SizeOf(BMP));
  with BMP do
  begin
    if Header.bfType <> $4D42 then
      Error('not a Windows bitmap file');
    if (Info.bmiHeader.biWidth <> 32)
    or (Info.bmiHeader.biHeight <> 32)
    or (Info.bmiHeader.biBitCount <> 4) then
      Error('not a 32x32x16 colors Windows bitmap');
  end;
  src.ReadBuffer(icXOR, SizeOf(icXOR));
  // transparent color
  t := icXOR[0, 0] and $F;
  for y := 0 to 31 do
    for x := 0 to 3 do
    begin // 4*8 bits = 32
      m := 0;
      for z := 0 to 3 do
      begin
        b := icXOR[y, 4 * x + z]; // 2 pixels
        m := m shl 1;
        if (b shr 4) = t then
        begin
          m := m or 1;
          b := b and $F;
        end;
        m := m shl 1;
        if (b and $F) = t then
        begin
          m := m or 1;
          b := (b and $F0);
        end;
        icXOR[y, 4 * x + z] := b;
      end;
      icAND[y, x] := m;
    end;
  dst := TFileStream.Create(FileName, fmCreate);
  with ICO do
  begin
    idReserved := 0;
    idType := 1;
    idCount := 1;
    bWidth := 32;
    bHeight := 32;
    bColorCount := 16;
    bReserved := 0;
    wPlanes := 0;
    wBitCount := 0;
    dwBytesInRes := 744;
    dwImageOffset := 22;
  end;
  dst.WriteBuffer(ICO, SizeOf(ICO));
  BMP.Info.bmiHeader.biHeight := 64;
  dst.WriteBuffer(BMP.Info, SizeOf(BMP.Info));
  dst.WriteBuffer(BMP.RGBA, SizeOf(BMP.RGBA));
  dst.WriteBuffer(icXOR, SizeOf(icXOR));
  dst.WriteBuffer(icAND, SizeOf(icAND));
  dst.free;
end;

procedure ICOToBMP(FileName: string);
var
  x, y, z: integer;
  t, b, m: byte;
begin
  src.ReadBuffer(ICO, SizeOf(ICO));
  src.ReadBuffer(BMP.Info, SizeOf(BMP.Info));
  src.ReadBuffer(BMP.RGBA, SizeOf(BMP.RGBA));
  src.ReadBuffer(icXOR, SizeOf(icXOR));
  src.ReadBuffer(icAND, SizeOf(icAND));

  for y := 0 to 31 do
    for x := 0 to 3 do
    begin // 4*8 bits = 32
      m := icAND[y, x];
      for z := 0 to 3 do
      begin
        b := icXOR[y, 4 * x + z]; // 2 pixels
        if (m and $80) > 0 then
          b := (b and $0F) + $30;
        m := m shl 1;
        if (m and $80) > 0 then
          b := (b and $F0) + $03;
        m := m shl 1;
        icXOR[y, 4 * x + z] := b; // 2 pixels
      end;
    end;

  dst := TFileStream.Create(FileName, fmCreate);
  with BMP do
  begin
    Header.bfType := $4D42;
    Header.bfSize := 630;
    Header.bfReserved1 := 0;
    Header.bfReserved2 := 0;
    Header.bfOffBits := 118;
    Info.bmiHeader.biHeight := 32;
  end;
  dst.WriteBuffer(BMP, SizeOf(BMP));
  dst.WriteBuffer(icXOR, SizeOf(icXOR));
  dst.free;
end;

begin
  if ParamCount = 1 then
  begin
    { one parameter ? convert file }
    src := TFileStream.Create(paramstr(1), 0);
    // check file type
    case Src.Size of
      630: BMPToICO(ChangeFileExt(ParamStr(1), 'ico'));
      766: ICOToBMP(ChangeFileExt(ParamStr(1), 'bmp'));
    else
      WriteLn('Expected a 32x32 Bitmap or an Icon');
    end;
  end;
  src.Free;
end.
