
program SearchDemo;

(* Essai de l'unité Search *)

uses
  SysUtils, Classes, Search;

var
  LList: TStringList;
  
begin
  LList := TStringList.Create;
  
  SearchFiles(
    LList,
    '.',
    Concat(
      '^',
      '(',
      '.+\.dbg',
      '|',
      '.+\.o',
      '|',
      '.+\.ppu',
      ')',
      '$'
    ),
    TRUE
  );
  
  WriteLn(Trim(LList.Text));
  
  LList.Free;
end.
