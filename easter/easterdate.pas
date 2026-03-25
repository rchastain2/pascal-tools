
{ @abstract(Date de Pâques dans les calendriers julien et grégorien.)
  Date de Pâques pour les années postérieures à 1582, par l'algorithme
  d'Oudin.
  
  L'algorithme d'Oudin permet de déterminer la date de Pâques pour
  n'importe quelle année du calendrier grégorien, c'est-à-dire pour
  n'importe quelle année postérieure à 1582.
  
  Lorsque le résultat de l'algorithme est un nombre inférieur ou égal à
  31, ce nombre correspond à un jour de mars. Lorsque le nombre est
  supérieur à 31, c'est que Pâques tombe en avril. Par exemple, si le
  nombre est égal à 32, c'est que Pâques tombe le 1er avril (le 32 mars
  pour ainsi dire). }

unit EasterDate;

{$IFDEF FPC}{$MODE OBJFPC}{$H+}{$ENDIF}

interface

{ Date de Pâques par l'algorithme d'Oudin pour une année donnée du
  calendrier grégorien. Renvoie le résultat sous la forme du jour de
  mars.
  
  Le comput julien est utilisé pour les années antérieures à 1583, et le
  comput grégorien pour les années postérieures, sauf si la valeur TRUE
  est passée comme second paramètre. }
function EasterNumber(const AYear: word; const AForceJulianComput: boolean = FALSE): word;

{ Date de Pâques par l'algorithme d'Oudin pour une année donnée du
  calendrier grégorien. Renvoie le mois et le jour. }
procedure GetEasterDate(const AYear: word; out AMonth, ADay: word; const AForceJulianComput: boolean = FALSE);

{ L'algorithme n'est pas valable pour les années antérieures à 325. }
const
  CMinYear = 325;

implementation

function EasterNumber(const AYear: word; const AForceJulianComput: boolean): word;
var
  g, c, e, h, k, p, q, i, b, j: integer;
begin
  if AYear < CMinYear then
    Exit(0);
  g := AYear mod 19;
  if (AYear < 1583) or AForceJulianComput then
  begin
    { Comput julien }
    i := (19 * g + 15) mod 30;
    j := (AYear + (AYear div 4) + i) mod 7;
  end else
  begin
    { Comput grégorien }
    c := AYear div 100;
    e := (8 * c + 13) div 25;
    h := (19 * g + c - (c div 4) - e + 15) mod 30;
    k := h div 28;
    p := 29 div (h + 1);
    q := (21 - g) div 11;
    i := (k * p * q - 1) * k + h;
    b := (AYear div 4) + AYear;
    j := (b + i + 2 + (c div 4) - c) mod 7;
  end;
  result := 28 + i - j;
end;

procedure GetEasterDate(const AYear: word; out AMonth, ADay: word; const AForceJulianComput: boolean);
var
  LEasterNumber: word;
begin
  LEasterNumber := EasterNumber(AYear, AForceJulianComput);
  
  if LEasterNumber > 31 then
  begin
    AMonth := 4;
    ADay := LEasterNumber - 31;
  end else
  begin
    AMonth := 3;
    ADay := LEasterNumber;
  end;
end;

end.
