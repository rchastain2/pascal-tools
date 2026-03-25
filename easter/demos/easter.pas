
{ @abstract(Exemple d'utilisation de l'unité EasterDate.)
  Date de Pâques pour une année donnée (à défaut, pour l'année courante. }

program Easter;

{$IFDEF FPC}{$MODE OBJFPC}{$H+}{$ENDIF}

uses
(*
{$IFDEF UNIX}
  clocale,
{$ENDIF}
*)
  SysUtils, Math, EasterDate;

{ Date de Pâques sous la forme d'une variable de type TDate. }
function EasterDate(const AYear: word): TDate;
var
  LMonth, LDay: word;
begin
  GetEasterDate(AYear, LMonth, LDay);
  result := EncodeDate(AYear, LMonth, LDay);
end;

var
  LYear: word;
  LEasterDate: TDate;
  
begin
  LYear := Max(CMinYear, StrToIntDef(ParamStr(1), CurrentYear));
  
  LEasterDate := EasterDate(LYear);
  
  WriteLn('Date of Easter in ', LYear, ': ', FormatDateTime('dddd dd mmmm', LEasterDate));
end.
