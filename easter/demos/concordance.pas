
program Concordance;

{ @abstract(Exemple d'utilisation des unités EasterDate et EasterTable.)
  Vérification de la concordance entre l'algorithme d'Oudin et une table
  des dates de Pâques de 1900 à 2199. }

{$IFDEF FPC}{$MODE OBJFPC}{$H+}{$ENDIF}

uses
  SysUtils, EasterDate, EasterTable;

var
  LYear: word;
  LSuccess: integer;
  
begin
  LSuccess := 0;
  
  for LYear := Low(CEasterNumber) to High(CEasterNumber) do
    if EasterNumber(LYear) = CEasterNumber[LYear] then
      Inc(LSuccess);
  
  WriteLn(Format('Concordance: %d/%d', [LSuccess, Length(CEasterNumber)]));
end.
