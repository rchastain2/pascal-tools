
program Demo;

uses
  SysUtils, Classes, Calendar, Config;

procedure ShowHelpAndExit;
begin
  WriteLn('Usage:');
  WriteLn('  demo [YEAR]');
  WriteLn;
  WriteLn('Shows a calendar for the current year, or for the year specified in parameter.');
  WriteLn('The YEAR parameter must be a number between 1 and 65535 different than 1582.');
  WriteLn('The programs shows a julian calendar for years prior to 1582, a gregorian calendar for posterior years.');
  Halt;
end;

const
{$IFDEF FRENCH}
  CFileName = 'calendrier-%d.txt';
{$ELSE}
  CFileName = 'calendar-%d.txt';
{$ENDIF}

var
  LParam: longint;
  LYear: word;
  LCalendar: TStringList;
  LJulianCalendar: boolean;
  
begin
  ReadConfig(LMondayFirst, LColCount);
  
  if not (LColCount in [1, 2, 3, 4, 6, 12]) then
  begin
    WriteLn(ErrOutput, 'Invalid columns number. Switching to default value (', CDefault_ColCount, ').');
    LColCount := CDefault_ColCount;
  end;
    
  LParam := StrToIntDef(ParamStr(1), CurrentYear);
  
  if (LParam < 0) or (LParam > $FFFF) then
  begin
    ShowHelpAndExit;
  end;
  
  LYear := LParam;
  
  case LYear of
    0:
      ShowHelpAndExit;
    1..1581:
      LJulianCalendar := TRUE;
    1582:
      ShowHelpAndExit;
    1583..$FFFF:
      LJulianCalendar := FALSE;
  end;
  
  LCalendar := TStringList.Create;
  GetYearCalendar(LYear, LCalendar, LJulianCalendar);
  
  WriteLn(LCalendar.Text);
  
  LCalendar.SaveToFile(Format(CFileName, [LYear]));
  
  LCalendar.Free;
  
  if not ConfigFileExists then
    WriteConfig(LMondayFirst, LColCount);
end.
