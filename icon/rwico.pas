
{
  https://github.com/RetroNick2020/raster-master-dos/blob/main/RM/RWICO.PAS
  https://github.com/RetroNick2020/raster-master/discussions/34#discussioncomment-16262434
}

unit RWico;

{$MODE objfpc}{$H+}

interface

function ReadIco(AFileName: string): word;
function WriteIco(AFileName: string): word;
function WriteIco2(AFileName: string): word;

implementation

uses
  StrUtils;

const
  CSize = 32;

type
  IcoBuf = array[1..CSize, 1..CSize] of byte;
  
  tagICOHDR = record
    icoReserved: word;
    icoResourceType: word;
    icoResourceCount: word;
  end;

  tagICODSC = record
    Width: byte;
    Height: byte;
    ColorCount: byte;
    Reserved1: byte;
    reserved2: word;
    Reserved3: word;
    icoDIBSize: longint;
    icoDIBOffset: longint;
  end;

const
  IcoColors: array[0..15] of word = (0, 4, 2, 6, 1, 5, 3, 8, 7, 12, 10, 14, 9, 13, 11, 15);
  
  Unknown: array[1..104] of byte = (
     40,  0,  0,  0, 32,  0,  0,  0, 64,  0,  0,  0,  1,  0,
      4,  0,  0,  0,  0,  0,128,  2,  0,  0,  0,  0,  0,  0,
      0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
      0,  0,  0,  0,128,  0,  0,128,  0,  0,  0,128,128,  0,
    128,  0,  0,  0,128,  0,128,  0,128,128,  0,  0,128,128,
    128,  0,192,192,192,  0,  0,  0,255,  0,  0,255,  0,  0,
      0,255,255,  0,255,  0,  0,  0,255,  0,255,  0,255,255,
      0,  0,255,255,255,  0
  );

var
  GIcoBuf: IcoBuf;
  GFile: file;
  Ihead: tagICOHDR;
  Idesc: tagICODSC;
  GImage: array[1..512] of byte;
  
function ValidIco(const AFileName: string): boolean;
var
  mf: file;
  mhead: tagicohdr;
  mdesc: tagicodsc;
  Error: word;
begin
{$I-}
  ValidIco := true;
  Assign(mf, AFileName);
  Reset(mf, 1);
  if FileSize(mf) <> 766 then
  begin
    result := False;
    Close(mf);
    exit;
  end;
  BlockRead(mf, mhead, SizeOf(mhead));
  BlockRead(mf, mdesc, SizeOf(mdesc));

  if (mdesc.Width <> 32) or (mdesc.Height <> 32) or (mdesc.ColorCount <> 16) then
  begin
    result := false;
  end;
  Close(mf);
  Error := IoResult();
{$I+}
end;

procedure ReadHead;
begin
{$I-}
  Blockread(GFile, ihead, SizeOf(ihead));
{$I+}
end;

procedure ReadDesc;
begin
{$I-}
  Blockread(GFile, idesc, SizeOf(idesc));
{$I+}
end;

procedure ReadImage;
var
  LPos: integer;
begin
{$I-}
  LPos := FileSize(GFile) - 640;
  WriteLn('DEBUG LPos ', LPos);
  Seek(GFile, LPos);
  BlockRead(GFile, GImage, SizeOf(GImage));
{$I+}
end;

procedure WriteHead;
begin
  Ihead.icoReserved := 0;
  Ihead.icoResourceType := 1;
  Ihead.icoResourceCount := 1;
  BlockWrite(GFile, ihead, SizeOf(ihead));
end;

procedure WriteDesc;
begin
  Idesc.Width := 32;
  Idesc.Height := 32;
  Idesc.ColorCount := 16;
  Idesc.Reserved1 := 0;
  Idesc.Reserved2 := 0;
  Idesc.Reserved3 := 0;
  Idesc.icoDIBSize := 744;
  Idesc.icoDIBOffset := 22;
  BlockWrite(GFile, idesc, SizeOf(idesc));
end;

procedure WriteUnknown;
begin
{$I-}
  BlockWrite(GFile, unknown, SizeOf(unknown));
{$I+}
end;

procedure WriteImage;
begin
{$I-}
  BlockWrite(GFile, GImage, SizeOf(GImage));
{$I+}
end;

procedure WriteTail;
var
  empty: array[1..128] of byte;
begin
  FillChar(empty, SizeOf(empty), 0);
{$I-}
  BlockWrite(GFile, empty, SizeOf(empty));
{$I+}
end;

procedure UnpackColor(color: byte; var c1, c2: byte);
begin
  c1 := color shr 4;
  c2 := color and %1111;
end;

procedure PackToArray(var AIcoBuf: IcoBuf);
var
  w: word;
  h: word;
  i: word;
  Colors: byte;
  Color1: byte;
  Color2: byte;
begin
  w := 1;
  h := 32;

  for i := 1 to 512 do
  begin
    Colors := GImage[i];
    if w > 31 then
    begin
      w := 1;
      dec(h);
    end;

    UnpackColor(Colors, Color1, Color2);
    AIcoBuf[w, h] := IcoColors[Color1];
    AIcoBuf[w + 1, h] := IcoColors[Color2];
    Inc(w, 2);
  end;
end;

function PackColors(c1, c2: byte): byte;
begin
  PackColors := c1 shl 4 + c2;
end;

procedure ArrayToPack(const AIcoBuf: IcoBuf);
var
  w: word;
  h: word;
  i: word;
  Color1: byte;
  Color2: byte;
begin
  w := 1;
  h := 32;

  for i := 1 to 512 do
  begin
    if w > 31 then
    begin
      w := 1;
      dec(h);
    end;

    Color1 := IcoColors[AIcoBuf[w, h]];
    Color2 := IcoColors[AIcoBuf[w + 1, h]];
    GImage[i] := PackColors(Color1, Color2);
    Inc(w, 2);
  end;
end;

function ReadIco(AFileName: string): word;
var
  FIcoBuf: IcoBuf;
  Error: word;
  i, j: word;
begin
{$I-}
  if not ValidIco(AFileName) then
  begin
    readIco := 1000;
    exit;
  end;
  FillChar(FIcoBuf, SizeOf(FIcoBuf), 0);
  FillChar(Idesc, SizeOf(idesc), 0);
  Assign(GFile, AFileName);
  Reset(GFile, 1);
  Error := IoResult();
  if Error <> 0 then
  begin
    ReadIco := Error;
    exit;
  end;

  ReadHead;
  ReadDesc;
  ReadImage;
  Close(GFile);
  Error := IoResult();
  if Error <> 0 then
  begin
    ReadIco := Error;
    exit;
  end;
  PackToArray(FIcoBuf);
  
  for i := 1 to CSize do
    for j := 1 to CSize do
      GIcoBuf[i, j] := FIcoBuf[i, j];

  result := IoResult();
{$I+}
end;

function WriteIco(AFileName: string): word;
var
  FIcoBuf: IcoBuf;
  i, j: word;
begin
{$I-}
  FillChar(FIcoBuf, SizeOf(FIcoBuf), 1);
  
  for i := 1 to CSize do
    for j := 1 to CSize do
      FIcoBuf[i, j] := GIcoBuf[i, j];

  ArrayToPack(FIcoBuf);
  Assign(GFile, AFileName);
  Rewrite(GFile, 1);
  WriteHead;
  WriteDesc;
  WriteUnknown;
  WriteImage;
  WriteTail;
  Close(GFile);
  result := IoResult();
{$I+}
end;

function WriteIco2(AFileName: string): word;
var
  FIcoBuf: IcoBuf;
  i, j: word;
  t: text;
  s: string;
begin
{$I-}
  FillChar(FIcoBuf, SizeOf(FIcoBuf), 1);
  
 {for i := 1 to CSize do
    for j := 1 to CSize do
      FIcoBuf[i, j] := GIcoBuf[i, j];}
  
  Assign(t, 'icon.txt');
  Reset(t);
  for i := 1 to 32 do
  begin
    ReadLn(t, s);
    for j := 1 to 32 do
      FIcoBuf[j, i] := Hex2Dec(s[j]);
  end;
  Close(t);
  
  ArrayToPack(FIcoBuf);
  Assign(GFile, AFileName);
  Rewrite(GFile, 1);
  WriteHead;
  WriteDesc;
  WriteUnknown;
  WriteImage;
  WriteTail;
  Close(GFile);
  result := IoResult();
{$I+}
end;

end.
