
program Easter;

uses
{$IFDEF UNIX}
  CLocale,
{$ENDIF}
  SysUtils, Math, LazUTF8, StrUtils,
  EasterDate, JulianDayNumber,
  Translation; { https://www.lazarusforum.de/viewtopic.php?f=29&t=11928 }

type
  TMoveableFeast = (
    Septuagesima,
    Sexagesima,
    Quinquagesima,
    Ash,
    Palm,
    EasterSunday,
    Ascension,
    Pentecost,
    Trinity,
    CorpusChristi
  );

const
  COffset: array[TMoveableFeast] of shortint = (-63, -56, -49, -46, -7, 0, 39, 49, 56, 60);

var
  LName: array[TMoveableFeast] of string;

procedure SetDefaultNames;
var
  LFeast: TMoveableFeast;
begin
  for LFeast in TMoveableFeast do
    WriteStr(LName[LFeast], LFeast);
end;

procedure TranslateDayNames(const ALanguage: string);
const
  CIniFile = 'lang.cfg';
begin
  if FileExists(CIniFile) then
  begin
    TransMgr.IniFile := CIniFile;
    TransMgr.Language := ALanguage;

    LName[Septuagesima]  := TransMgr.GetString('septuagesima');
    LName[Sexagesima]    := TransMgr.GetString('sexagesima');
    LName[Quinquagesima] := TransMgr.GetString('quinquagesima');
    LName[Ash]           := TransMgr.GetString('ash');
    LName[Palm]          := TransMgr.GetString('palm');
    LName[EasterSunday]  := TransMgr.GetString('easter');
    LName[Ascension]     := TransMgr.GetString('ascension');
    LName[Pentecost]     := TransMgr.GetString('pentecost');
    LName[Trinity]       := TransMgr.GetString('trinity');
    LName[CorpusChristi] := TransMgr.GetString('corpuschristi');
  end else
    WriteLn(ErrOutput, 'Cannot find ', CIniFile);
end;

const
  CFrench = 'fr-fr';

var
  LLang: string;
  LYear, LEasterNumber: word;
  LEasterJDN, LJDN: integer;
  LApril: byte;
  LFeast: TMoveableFeast;
  LMonth, LDay: word;
  LDate: TDate;

begin
  LYear := Max(CMinYear, StrToIntDef(ParamStr(1), CurrentYear));
  LLang := IfThen(ParamCount > 1, ParamStr(2), CFrench);

  { Date de Pâques. }
  LEasterNumber := EasterNumber(LYear);
  LApril := Ord(LEasterNumber > 31);

  { Conversion de la date de Pâques en jour julien. }
  LEasterJDN := DateToJulianDayNumber(LYear, 3 + LApril, LEasterNumber - 31 * LApril);

  SetDefaultNames;
  TranslateDayNames(LLang);
  
  WriteLn('\begin{center}');
  WriteLn('\textbf{Fêtes mobiles pour l''année ', LYear, '}');
  WriteLn('\end{center}');
  WriteLn('');
  WriteLn('\begin{table}[h]');
  WriteLn('\caption{Dates de Pâques et des fêtes mobiles}');
  WriteLn('\centering');
  WriteLn('\begin{tabular}{ll}');
  WriteLn('\toprule');
  WriteLn('Fête ou solennité & Date\\');
  WriteLn('\midrule');
  
  for LFeast in [Ash..Trinity] do
  begin
    LJDN := LEasterJDN + COffset[LFeast];
    JulianDayNumberToDate(LJDN, LYear, LMonth, LDay);
    LDate := EncodeDate(LYear, LMonth, LDay);
    
    WriteLn(LName[LFeast], ' & ', FormatDateTime('dddd dd mmmm', LDate), '\\');
  end;
  
  WriteLn('\bottomrule');
  WriteLn('\end{tabular}');
  WriteLn('\end{table}');
end.
