
unit Configuration;

interface

procedure LoadConfiguration(const AConfigFilePath: string; out AHost, AUserName, APassword, ALocalDir: string);
procedure SaveConfiguration(const AConfigFilePath: string; const AHost, AUserName, APassword, ALocalDir: string);

implementation

uses
  IniFiles;

const
  CSection = '.';

procedure LoadConfiguration(const AConfigFilePath: string; out AHost, AUserName, APassword, ALocalDir: string);
var
  LConfigFile: TIniFile;
begin
  LConfigFile := TIniFile.Create(AConfigFilePath);
  try
    AHost := LConfigFile.ReadString(CSection, 'host', '');
    AUserName := LConfigFile.ReadString(CSection, 'username', '');
    APassword := LConfigFile.ReadString(CSection, 'password', '');
    ALocalDir := LConfigFile.ReadString(CSection, 'localdir', '');
  finally
    LConfigFile.Free;
  end;
end;

procedure SaveConfiguration(const AConfigFilePath: string; const AHost, AUserName, APassword, ALocalDir: string);
var
  LConfigFile: TIniFile;
begin
  LConfigFile := TIniFile.Create(AConfigFilePath);
  try
    LConfigFile.WriteString(CSection, 'host', AHost);
    LConfigFile.WriteString(CSection, 'username', AUserName);
    LConfigFile.WriteString(CSection, 'password', APassword);
    LConfigFile.WriteString(CSection, 'localdir', ALocalDir);
  finally
    LConfigFile.Free;
  end;
end;

end.
