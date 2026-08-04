
uses
  SysUtils, RWico;

const
  CNewFile = 'test.ico';

var
  LSrcFile: string;
  result: word;
  
begin
  LSrcFile := ParamStr(1);
  
  result := ReadIco(LSrcFile);
  WriteLn('DEBUG ReadIco ', result, '');
  
  result := WriteIco(CNewFile);
  WriteLn('DEBUG WriteIco ', result, '');
  
  result := ExecuteProcess('/usr/bin/diff', [LSrcFile, CNewFile], []);
  WriteLn('DEBUG diff ', result, '');
end.
