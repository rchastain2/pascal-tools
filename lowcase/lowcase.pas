
uses
  SysUtils, Log;

function LowerCaseLastPart(const APath: string): string;
var
  i: integer;
begin
  i := Pred(Length(APath));
  if i > -1 then
  begin
    while (i > 1) and (APath[i] <> DirectorySeparator) do
      Dec(i);
    
    result := Copy(APath, 1, i - 1) + LowerCase(Copy(APath, i));
    
    LogLn(Format('DEBUG %s -> %s', [APath, result]));
  end else
    result := EmptyStr;
end;

procedure RenameF(const APath: string);
var
  LNewName: string;
begin
{$IFDEF WINDOWS}
  FileSetAttr(APath, faArchive);
{$ENDIF}
  LogLn(Format('DEBUG RenameF %s', [APath])); Exit; // <---
  
  LNewName := LowerCaseLastPart(APath);
  
  if LNewName = APath then
  begin
    LogLn('DEBUG Nothing to do');
    Exit;
  end;
  if FileExists(LNewName) then
  begin
    LogLn(Format('WARNING ' + {$I %LINE%} + ' Cannot rename file %s', [APath]));
    Exit;
  end;
  if not RenameFile(APath, LNewName) then
    LogLn(Format('WARNING ' + {$I %LINE%} + ' Cannot rename file %s', [APath]));
end;

procedure RenameD(const APath: string);
var
  LNewName: string;
begin
  LogLn(Format('DEBUG RenameD %s', [APath]));
  
  LNewName := LowerCaseLastPart(APath);
  LNewName := StringReplace(LNewName, '_', '-', [rfReplaceAll]);
  
  if LNewName = APath then
  begin
    LogLn('DEBUG Nothing to do');
    Exit;
  end;
  if DirectoryExists(LNewName) then
  begin
    LogLn(Format('WARNING ' + {$I %LINE%} + ' Cannot rename directory %s', [APath]));
    Exit;
  end;
  if not RenameFile(APath, LNewName) then
    LogLn(Format('WARNING ' + {$I %LINE%} + ' Cannot rename directory %s', [APath]));
end;

procedure RenameT(const APath: string);
var
  LRoot: string;
  LRec: TSearchRec;
  LFind: integer;
begin
  LRoot := IncludeTrailingPathDelimiter(APath);
  LogLn(Format('DEBUG RenameT %s', [LRoot]));
  LFind := FindFirst(LRoot + '*', faAnyFile or faDirectory, LRec);
  while LFind = 0 do
  begin
    if (LRec.Attr and faDirectory) = faDirectory then
    begin
      if  (LRec.Name <> '.')
      and (LRec.Name <> '..') then
        RenameT(Concat(LRoot, LRec.Name));  { Rename tree }
    
    end else
      RenameF(Concat(LRoot, LRec.Name)); { Rename file }
    
    LFind := FindNext(LRec);
  end;
  
  RenameD(LRoot); { Rename directory }
  
  FindClose(LRec);
end;

begin
  if DirectoryExists(ParamStr(1)) then
  
    RenameT(ParamStr(1)) { Rename tree }
    
  else
    LogLn(Format('WARNING ParamStr(1) = [%s]', [ParamStr(1)]), TRUE);
end.
