
unit Calendar;

interface

uses
  SysUtils, Classes;
  
procedure GetMonthCalendar(const AYear, AMonth: word; AStrings: TStrings; const AJulianCalendar: boolean = FALSE);
procedure GetYearCalendar(const AYear: word; AStrings: TStrings; const AJulianCalendar: boolean = FALSE);

var
  LMondayFirst: boolean = FALSE; { Lundi premier jour de la semaine. }
  LColCount: integer = 3; { Nombre de mois sur la même ligne. }

{$IFDEF FRENCH}
{$I french.inc}
{$ELSE}
{$I english.inc}
{$ENDIF}

implementation

const
  CSunday = 0;
  CSaturday = 6;

type
  TWeekDay = CSunday..CSaturday;

function WeekDay(const AYear, AMonth, AJour: word; const AJulianCalendar: boolean = FALSE): TWeekDay;
{
  Jour de la semaine pour une date donnée.
  https://www.tondering.dk/claus/cal/chrweek.php
}
var
  i, j, k, l: word;
begin
  i := (14 - AMonth) div 12;
  j := AYear - i;
  k := AMonth + 12 * i - 2;
  l := AJour + j + j div 4 + 31 * k div 12;
  if AJulianCalendar
  then l := l + 5
  else l := l - j div 100 + j div 400; { Date grégorienne. }
  result := l mod 7;
end;

function LeapYear(const AYear: word; const AJulianCalendar: boolean = FALSE): boolean;
begin
  result := (AYear mod 4 = 0) and ((AYear mod 100 <> 0) or (AYear mod 400 = 0) or AJulianCalendar);
end;

function StrLen(const AStr: string): integer;
var
  i: integer;
begin
 {if StringCodePage(AStr) = CP_UTF8 then
  begin}
    result := 0;
    for i := 1 to Length(AStr) Do
      if (byte(AStr[i]) and $C0) <> $80 then
        Inc(result);
 {end else
    result := Length(AStr);}
end;

function Line(const AStr: string; const ALen: integer): string;
var
  i: integer;
begin
  i := ALen - StrLen(AStr);
  result := Concat(
    StringOfChar(' ', i div 2), AStr,
    StringOfChar(' ', i - i div 2)
  );
end;

procedure GetMonthCalendar(const AYear, AMonth: word; AStrings: TStrings; const AJulianCalendar: boolean = FALSE);
const
  CDaysInMonth: array[1..12] of integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var
  LMonthDay: word;
  LStr: string;
  LMonthName: string;
  LWeekDay: integer;
  LDaysInMonth: integer;
  i: integer;
begin
  LMonthName := CMonthName[AMonth];
  AStrings.Append(Line(LMonthName, 7 * 3));
  AStrings.Append(CDayNames[LMondayFirst]);
  LWeekDay := WeekDay(AYear, AMonth, 1, AJulianCalendar);
  LDaysInMonth := CDaysInMonth[AMonth] + Ord((AMonth = 2) and LeapYear(AYear, AJulianCalendar));
  if LMondayFirst then
  begin
    Dec(LWeekDay);
    if LWeekDay = -1 then
      LWeekDay := 6;
  end;
  LStr := StringOfChar(' ', 3 * LWeekDay);
  for LMonthDay := 1 to LDaysInMonth do
    LStr := Concat(LStr, Format('%3d', [LMonthDay]));
  LStr := Concat(LStr, StringOfChar(' ', (7 * 6 - LDaysInMonth - LWeekDay) * 3));
  for i := 1 to 6 do
    AStrings.Append(Copy(LStr, 7 * 3 * Pred(i) + 1, 7 * 3));
end;

procedure GetYearCalendar(const AYear: word; AStrings: TStrings; const AJulianCalendar: boolean = FALSE);
const
  CMargin = 3;
var
  LMonthCalendar: array [1..12] of TStringList;
  LStr: string;
  LTitle: string;
  i, j, k: integer;
begin
  for i := 1 to 12 do
  begin
    LMonthCalendar[i] := TStringList.Create;
    GetMonthCalendar(AYear, i, LMonthCalendar[i], AJulianCalendar);
  end;
  AStrings.Append('');
  LTitle := Format(CTitle, [AYear]);
  AStrings.Append(Line(LTitle, LColCount * (7 * 3 + CMargin)));
  for i := 0 to Pred(12 div LColCount) do
  begin
    AStrings.Append('');
    for j := 0 to 7 do
    begin
      LStr := '';
      for k := 1 to LColCount do
        LStr := Concat(LStr, StringOfChar(' ', CMargin), LMonthCalendar[k + i * LColCount][j]);
      AStrings.Append(LStr);
    end;
  end;
  for i := 1 to 12 do
    LMonthCalendar[i].Free;
end;

end.
