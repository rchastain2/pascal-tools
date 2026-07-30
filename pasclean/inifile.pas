
unit IniFile;

interface

uses
  SysUtils, IniFiles;
  
type
  TIniFileEx = class(TIniFile)
    function ReadBoolean(const Section: string; const Ident: string; Default: boolean): boolean;
    procedure WriteBoolean(const Section: string; const Ident: string; Value: boolean);
  end;
  
implementation

function TIniFileEx.ReadBoolean(const Section: string; const Ident: string; Default: boolean): boolean;
begin
  result := StrToBool(ReadString(Section, Ident, BoolToStr(Default, TRUE)));
end;

procedure TIniFileEx.WriteBoolean(const Section: string; const Ident: string; Value: boolean);
begin
  WriteString(Section, Ident, BoolToStr(Value, TRUE));
end;

end.
