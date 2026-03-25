
unit main;

{$IFDEF FPC}{$MODE objfpc}{$H+}{$ENDIF}

interface

uses
  msetypes,
  mseglob,
  mseguiglob,
  mseguiintf,
  mseapplication,
  msestat,
  msemenus,
  msegui,
  msegraphics,
  msegraphutils,
  mseevent,
  mseclasses,
  msewidgets,
  mseforms,
  mseact,
  msedataedits,
  msedropdownlist,
  mseedit,
  mseificomp,
  mseificompglob,
  mseifiglob,
  msestatfile,
  msestream,
  sysutils,
  msedispwidgets,
  mserichstring,
  msesimplewidgets;

type
  tmainfo = class(tmainform)
    edYear: tintegeredit;
    dsEasterNum: tintegerdisp;
    btCompute: tbutton;
    dsEasterDate: tstringdisp;
    dsAshDate: tstringdisp;
    procedure formcreate(const sender: TObject);
    procedure buttonclick(const sender: TObject);
  end;

var
  mainfo: tmainfo;

implementation

uses
  main_mfm,
  easterdate,
  juliandaynumber;

(* ========================================================================== *)

function JulianDayNumberToDate(const ANumber: integer): TDate;
var
  LYear, LMonth, LDay: word;
begin
  juliandaynumber.JulianDayNumberToDate(ANumber, LYear, LMonth, LDay);
  result := EncodeDate(LYear, LMonth, LDay);
end;

(* ========================================================================== *)

procedure tmainfo.formcreate(const sender: TObject);
begin
  edYear.value := CurrentYear;
end;

procedure tmainfo.buttonclick(const sender: TObject);
var
  LApril: boolean;
  LDate: TDate;
  LJulianDayNumber: integer;
begin
  { Nombre d'Oudin }
  dsEasterNum.value := EasterNumber(edYear.value);
  { Date de Pâques }
  LApril := dsEasterNum.value > 31;
  LDate := EncodeDate(edYear.value, Ord(LApril) + 3, dsEasterNum.value - 31 * Ord(LApril));
  //dsEasterDate.value := FormatDateTime('dddd dd mmmm', LDate);
  dsEasterDate.value := FormatDateTime('dd mmmm', LDate);
  { Jour julien }
  LJulianDayNumber := DateToJulianDayNumber(
    edYear.value,
    3 + Ord(LApril),
    dsEasterNum.value - 31 * Ord(LApril)
    );
  { Date des Cendres }
  LDate := JulianDayNumberToDate(LJulianDayNumber - 46);
  //dsAshDate.value := FormatDateTime('dddd dd mmmm', LDate);
  dsAshDate.value := FormatDateTime('dd mmmm', LDate);
end;

end.
