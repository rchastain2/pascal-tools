
{ @abstract(Exemple d'utilisation des jours juliens.)
  Programme qui calcule la différence de jours entre deux dates. }

program HowManyDays;

{$IFDEF FPC}{$MODE OBJFPC}{$H+}{$ENDIF}

uses
{$IFDEF UNIX}
  clocale,
{$ENDIF}
  SysUtils, JulianDayNumber;

var
  s: string;
  dt: TDate;
  y, m, d: word;
  n1, n2: integer;
  
begin
  WriteLn('How many days have you lived?');
  
  with DefaultFormatSettings do
    Write(
      'Please enter your birth date (', 
      StringReplace(ShortDateFormat, '/', DateSeparator, [rfReplaceAll]),
      '): '
    );
  
  ReadLn(s);
  
  if TryStrToDate(s, dt) then
  begin
    DecodeDate(dt, y, m, d);
    n1 := DateToJulianDayNumber(y, m, d);
    WriteLn('Julian day number for your birth date: ', n1);
    
    DecodeDate(Date, y, m, d);
    n2 := DateToJulianDayNumber(y, m, d);
    WriteLn('Julian day number for today: ', n2);
    
    WriteLn(Format('You have lived %d - %d = %d days', [n2, n1, n2 - n1]));
  end else
    WriteLn('Invalid input');
end.
