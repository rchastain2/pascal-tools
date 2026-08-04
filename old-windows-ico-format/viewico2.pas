
{ https://github.com/gladir/corail/blob/master/VIEWICO.PAS }

{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/corail)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

program VIEWICO;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

(* -------------------------------------------------------------------------- *)

type
  IconDirEntry = packed record
    bWidth: byte;
    bHeight: byte;
    bColorCount: byte;
    bReserved: byte;
    wPlanes: word;
    wBitCount: word;
    dwBytesInRes: longint;
    dwImageOffset: longint;
  end;

  IconHeader = packed record
    idReserved: word;
    idType: word;
    idCount: word;
    idEntries: array[0..1] of IconDirEntry;
  end;

  BitmapInfoHeader = packed record
    biSize: longint;
    biWidth: longint;
    biHeight: longint;
    biPlanes: word;
    biBitCount: word;
    biCompression: longint;
    biSizeImage: longint;
    biXPelsPerMeter: longint;
    biYPelsPerMeter: longint;
    biClrUsed: longint;
    biClrImportant: longint;
  end;

(* -------------------------------------------------------------------------- *)

var
  hdr: IconHeader;
  bytes: array[0..4095] of byte;
  bmp: BitMapInfoHeader absolute bytes;
  gd, gm: smallint;
  y, x, r, i: integer;
  f: file;
  
begin
  if ParamCount > 0 then
  begin
{$I-}
    Assign(f, ParamStr(1));
    Reset(f, 1);
{$I+}
    if IOResult <> 0 then
    begin
      WriteLn('Impossible de lire le fichier');
      Exit;
    end;
    
    gd := d4bit;
    gm := m640x480;
    InitGraph(gd, gm, '');
    
    SetFillStyle(SolidFill, White);
    Bar(0, 0, 33, 33);
    
    WriteLn('DEBUG SizeOf(IconHeader) ', SizeOf(IconHeader));
    WriteLn('DEBUG SizeOf(BitmapInfoHeader) ', SizeOf(BitmapInfoHeader));
    
    BlockRead(f, hdr, SizeOf(hdr), r);
    
    WriteLn('DEBUG r ', r);
    WriteLn('DEBUG idCount ', hdr.idCount);
    WriteLn('DEBUG idType ', hdr.idType);
    
    with hdr.idEntries[0] do
    begin
      WriteLn('DEBUG bWidth ', bWidth);
      WriteLn('DEBUG bHeight ', bHeight);
      WriteLn('DEBUG dwBytesInRes ', dwBytesInRes);
      WriteLn('DEBUG dwImageOffset ', dwImageOffset);
      
      Seek(f, dwImageOffset);
      BlockRead(f, bytes, dwBytesInRes, r);
      
      WriteLn('DEBUG r ', r);
      WriteLn('DEBUG biBitCount ', bmp.biBitCount);
      
      for y := 0 to Pred(bHeight) do
        for x := 0 to Pred(bWidth shr 1) do
        begin
          i := 104 + y * (bWidth shr 1) + x;
          PutPixel(2 * x + 1, bHeight - y, bytes[i] shr 4);
          PutPixel(2 * x + 2, bHeight - y, bytes[i] and $F);
        end;
    end;
    Close(f);
    
    ReadKey;
    CloseGraph;
  end;
end.
