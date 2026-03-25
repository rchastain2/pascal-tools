
unit Config;

interface

procedure ReadConfig(var AMondayFirst: boolean; var AColCount: integer);
procedure WriteConfig(const AMondayFirst: boolean; const AColCount: integer);
function ConfigFileExists: boolean;

const
  CDefault_ColCount = 6;

implementation

uses
  SysUtils, IniFiles;

const
  CSection = 'options';
  CKey_MondayFirst = 'mondayfirst';
  CKey_ColCount = 'colcount';

var
  LConfigFileName: TFileName;

procedure ReadConfig(var AMondayFirst: boolean; var AColCount: integer);
const
  CDefault_MondayFirst = 0;
var
  LFile: TIniFile;
begin
  LFile := TIniFile.Create(LConfigFileName);
  try
    AMondayFirst := LFile.ReadInteger(CSection, CKey_MondayFirst, CDefault_MondayFirst) <> 0;
    AColCount := LFile.ReadInteger(CSection, CKey_ColCount, CDefault_ColCount);
  finally
    LFile.Free;
  end;
end;

procedure WriteConfig(const AMondayFirst: boolean; const AColCount: integer);
var
  LFile: TIniFile;
begin
  LFile := TIniFile.Create(LConfigFileName);
  try
    LFile.WriteInteger(CSection, CKey_MondayFirst, Ord(AMondayFirst));
    LFile.WriteInteger(CSection, CKey_ColCount, AColCount);
  finally
    LFile.Free;
  end;
end;

function ConfigFileExists: boolean;
begin
  result := FileExists(LConfigFileName);
end;

initialization
  LConfigFileName := ChangeFileExt(ParamStr(0), '.ini');

end.
