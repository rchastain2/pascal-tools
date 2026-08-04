
uses
  SysUtils, RWico;

const
  CNewFile = 'test.ico';

var
  LPicture: array[0..31, 0..31] of char;
  LFile: textfile;
  result: word;
  x, y, i: integer;
  
begin
  FillChar(LPicture, SizeOf(LPicture), 'F');
  
  for x := 0 to 31 do
    for y := 0 to 31 do
      LPicture[x, y] := IntToHex(
        //(x + y) mod 16,
        //4 * ((31 - y) div 8) + x div 8,
        //(x xor y) mod 8,
        (x + y) mod 4,
        1)[1];
  
  AssignFile(LFile, 'icon.txt');
  Rewrite(LFile);
  for y := 31 downto 0 do
  begin
    for x := 0 to 31 do
      Write(LFile, LPicture[x, y]);
    WriteLn(LFile);
  end;
  
  CloseFile(LFile);
  
  result := WriteIco2(CNewFile);
  WriteLn('DEBUG WriteIco ', result, '');
end.
