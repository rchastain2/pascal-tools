
program HexDump;

{$IFDEF WINDOWS}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  SysUtils;

function IIf(const aCondition: boolean; const aTrueResult, aFalseResult: char): char;
begin
  if aCondition then result := aTrueResult else result := aFalseResult;
end;

var
  buffer: array[1..16] of char;
  offset: integer;

procedure WriteLine(const aCharCount: integer);
var
  i: integer;
begin
  Write(Format('$%0.8X  ', [offset]));
  for i := 1 to aCharCount do Write(Format('%0.2X ', [Ord(buffer[i])]));
  Write(StringOfChar(' ', 3 * (16 - aCharCount) + 1));
  for i := 1 to aCharCount do Write(IIf(buffer[i] in [#33..#126], buffer[i], '.'));
  WriteLn;
end;

var
  i: integer;

begin
  WriteLn('           00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  0123456789ABCDEF');
  WriteLn;
  
  i := 1;
  offset := 0;
  
  while not Eof do
  begin
    Read(buffer[i]);
    
    if i = 16 then
    begin
      WriteLine(i);
      i := 1;
      Inc(offset, 16);
    end else
      Inc(i);
  end;
  
  if i > 1 then
  begin
    Dec(i);
    WriteLine(i);
  end;
end.
