
program PasClean;

(* Directory cleaner *)

uses
  SysUtils, Classes,
  SimpleLog, { https://github.com/ikelaiah/simplelog-fp }
  IniFile, Search;

const
  CBuild       = 'FPC ' + {$I %FPCVERSION%} + ' ' + {$I %DATE%} + ' ' + {$I %TIME%} + ' ' + {$I %FPCTARGETOS%} + '-' + {$I %FPCTARGETCPU%};
  CIniSection  = 'settings';
  CDefaultExpr =
    '^' +
    '(' +
    '.+\.bak' +
    '|' +
    '.+\.compiled' +
    '|' +
    '.+\.dbg' +
    '|' +
    '.+\.o' +
    '|' +
    '.+\.or' +
    '|' +
    '.+\.ppu' +
    ')' +
    '$';
  CDefaultRecursion = TRUE;

var
  LList: TStringList;
  LFileName: TFileName;
  LDir, LExpr: string;
  LRecursion: boolean;
  LLog: TSimpleLog;

begin
  LLog := TSimpleLog.Both(ChangeFileExt(ParamStr(0), '.log'));
  LLog.Info(CBuild);
  
  LFileName := ChangeFileExt(ParamStr(0), '.ini');
  
  if FileExists(LFileName) then
  begin
    with TIniFileEx.Create(LFileName) do
    try
      LExpr := ReadString(CIniSection, 'expr', CDefaultExpr);
      LRecursion := ReadBoolean(CIniSection, 'subdirs', CDefaultRecursion);
    finally
      Free;
    end;
    
    if ParamCount = 0 then
    begin
      LLog.Error('Missing parameter');
      LLog.Info('Usage: %s DIRECTORY', [ExtractFileName(ParamStr(0))]);
    end else
    begin
      LDir := ParamStr(1);

      if DirectoryExists(LDir) then
      begin
        LList := TStringList.Create;
        (* Recherche des fichiers *)
        SearchFiles(LList, LDir, LExpr, LRecursion);
        (* Suppression *)
        for LFileName in LList do
          if DeleteFile(LFileName) then
            LLog.Info('Deleted ' + LFileName)
          else
            LLog.Warning('Could not delete ' + LFileName);

        LList.Free;
      end else
        LLog.Warning('Directory not found: ' + LDir);
    end;
  end else
  begin
    LLog.Warning('File not found: ' + LFileName);
    LLog.Info('Creating ' + LFileName);

    with TIniFileEx.Create(LFileName) do
    try
      WriteString(CIniSection, 'expr', CDefaultExpr);
      WriteBoolean(CIniSection, 'subdirs', CDefaultRecursion);
      UpdateFile;
    finally
      Free;
    end;

    LLog.Info('Edit the file, to adapt it to your own needs, and run the program again.');
  end;
end.
