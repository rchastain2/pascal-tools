
unit Search;

(* Recherche récursive de fichiers dont le nom correspond à une expression régulière *)

interface

uses
  SysUtils, Classes, RegExpr;

procedure SearchFiles(AList: TStrings; const APath, AExpr: string; const ASubDirs: boolean = FALSE);

implementation

procedure SearchFiles(AList: TStrings; const APath, AExpr: string; const ASubDirs: boolean);
var
  LExpr: TRegExpr;
  
  procedure SearchFiles2(const APath2: string);
  var
    LRec: TSearchRec;
    LPath, LName: string;
  begin
    LPath := IncludeTrailingPathDelimiter(APath2);
    
{$IFDEF DEBUG}
    WriteLn(StdErr, 'Search directory ', LPath);
{$ENDIF}
    
    if FindFirst(
      Concat(LPath, '*'),
      faAnyFile or faDirectory,
      LRec
    ) = 0 then
    begin
      repeat
        LName := Concat(LPath, LRec.Name);
        
        if (LRec.Attr and faDirectory) = faDirectory then
        begin
          if ASubDirs
          and (LRec.Name <> '.')
          and (LRec.Name <> '..') then
            SearchFiles2(LName)
        end else
          if LExpr.Exec(LRec.Name) then
            AList.Append(LName);
      until FindNext(LRec) <> 0;
      FindClose(LRec);
    end;
  end;

begin
  LExpr := TRegExpr.Create(AExpr);
  
  try
    LExpr.Exec('');
  except
    on E: Exception do
    begin
      WriteLn(StdErr, E.Message);
      LExpr.Free;
      Exit;
    end;
  end;
  
  SearchFiles2(APath);
  
  LExpr.Free;
end;

end.
