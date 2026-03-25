
{ @abstract(Opérations sur les jours juliens.)
  Conversion d'une date du calendrier grégorien en jour julien. Conversion d'un jour julien en date
  du calendrier grégorien.
  Les algorithmes proviennent de la
  @html(<a href="http://www.tondering.dk/claus/cal/julperiod.php">FAQ calendrier</a>)
  de Claus Tøndering. }

unit JulianDayNumber;

{$IFDEF FPC}{$MODE OBJFPC}{$H+}{$ENDIF}

interface

uses
  SysUtils;

type
  TCalendar = (Julian, Gregorian);

{ Conversion d'une date en jour julien. }
function DateToJulianDayNumber(const AYear, AMonth, ADay: word; const ACalendar: TCalendar = Gregorian): integer;

{ Conversion d'un jour julien en date. }
procedure JulianDayNumberToDate(const ANumber: integer; out AYear, AMonth, ADay: word; const ACalendar: TCalendar = Gregorian);

implementation

function DateToJulianDayNumber(const AYear, AMonth, ADay: word; const ACalendar: TCalendar): integer;
var
  a, b, c: integer;
begin
  a := (14 - AMonth) div 12;
  b := AYear + 4800 - a;
  c := AMonth + 12 * a - 3;
  
  case ACalendar of
    Julian:    result := ADay + (153 * c + 2) div 5 + 365 * b + b div 4 - 32083;
    Gregorian: result := ADay + (153 * c + 2) div 5 + 365 * b + b div 4 - b div 100 + b div 400 - 32045;
  end;
end;

procedure JulianDayNumberToDate(const ANumber: integer; out AYear, AMonth, ADay: word; const ACalendar: TCalendar);
var
  a, b, c, d, e, f: integer;
begin
  case ACalendar of
    Julian:
      begin
        b := 0;
        c := ANumber + 32082;
      end;
    Gregorian:
      begin
        a := ANumber + 32044;
        b := (4 * a + 3) div 146097;
        c := a - (146097 * b) div 4;
      end;
  end;
  
  d := (4 * c + 3) div 1461;
  e := c - ((1461 * d) div 4);
  f := (5 * e + 2) div 153;
  ADay := e - ((153 * f + 2) div 5) + 1;
  AMonth := f + 3 - 12 * (f div 10);
  AYear := 100 * b + d - 4800 + f div 10;
end;

end.
