
unit Log;

interface

uses
  SysUtils, Classes;

procedure LogLn(const ALine: string; const ARewrite: boolean = FALSE);
  
implementation

var
  LLogName: TFileName;
  
procedure LogLn(const ALine: string; const ARewrite: boolean);
var
  LLog: TextFile;
  LTime: string;
begin
  Assign(LLog, LLogName);
  if ARewrite or not FileExists(LLogName) then
    Rewrite(LLog)
  else
    Append(LLog);
  LTime := FormatDateTime('hh:nn:ss:zzz', Now);
  WriteLn(LLog, LTime, ' ', ALine);
  Close(LLog);
end;
  
begin
  LLogName := ChangeFileExt(ParamStr(0), '.log');
end.
