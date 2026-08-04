{

   Dos icon viewer

               ╔════════════════════════════════════════╗
               ║                                        ║░
               ║          AVONTURE CHRISTOPHE           ║░
               ║              AVC SOFTWARE              ║░
               ║     BOULEVARD EDMOND MACHTENS 157/53   ║░
               ║           B-1080 BRUXELLES             ║░
               ║              BELGIQUE                  ║░
               ║                                        ║░
               ╚════════════════════════════════════════╝░
               ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcGraph,
  ptcCrt;

type
  TIcon = array[0..1023] of byte;
  PIcon = ^TIcon;

procedure ShowIco(AFileName: string);
var
  icon: PIcon;
  color: byte;
  f: file;
  x, y: integer;
begin
  GetMem(icon, 1024);
  
  Assign(f, AFileName);
  Reset(f, 1);
  
  BlockRead(f, icon^, 126);
  
  for x := 0 to 511 do
  begin
    BlockRead(f, color, 1);
    icon^[x shl 1] := color shr 4;
    icon^[(x shl 1) + 1] := color and $0F;
  end;
  
  Close(f);

  for y := 31 downto 0 do
    for x := 31 downto 0 do
      PutPixel(x + 1, 32 - y, icon^[x + y shl 5]);

  FreeMem(icon);
end;

var
  gd, gm: smallint;

begin
  if (ParamCount > 0)
  and FileExists(ParamStr(1)) then
  begin
     gd := EGA;
     gm := EGAHi;
     InitGraph(gd, gm, '');
     SetFillStyle(SolidFill, White);
     Bar(0, 0, 33, 33);
     ShowIco(Paramstr(1));
     ReadKey;
  end else
    WriteLn('Usage:', LineEnding, '  ', ExtractFileName(ParamStr(0)), ' FILE.ico');
end.
