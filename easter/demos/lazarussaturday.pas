
{ @abstract(Exemple d'utilisation des unités EasterDate et
  JulianDayNumber.)
  Date du samedi de Lazarus pour une année donnée. La date est calculée
  en utilisant le calendrier julien, puis convertie en date du
  calendrier grégorien. }

program LazarusSaturday;

{$IFDEF FPC}{$MODE OBJFPC}{$H+}{$ENDIF}

uses
  SysUtils, Math, EasterDate, JulianDayNumber;

const
  CJulianComput = TRUE;
  
var
  LYear, LMonth, LDay: word;
  LJDNumber: integer;
  LLazarusSaturday: TDate;
  
begin
  LYear := Max(CMinYear, StrToIntDef(ParamStr(1), CurrentYear));
  
  GetEasterDate(LYear, LMonth, LDay, CJulianComput);
  
  LJDNumber := DateToJulianDayNumber(LYear, LMonth, LDay, Julian);
  
  Dec(LJDNumber, 8);
  
  JulianDayNumberToDate(LJDNumber, LYear, LMonth, LDay, Gregorian);
  
  LLazarusSaturday := EncodeDate(LYear, LMonth, LDay);
  
  WriteLn('Lazarus Saturday ', LYear, ': ', FormatDateTime('dd/mm', LLazarusSaturday));
end.
