function t = ang2t(btAng,feedrate,n)
%ANG2T Berechnet Zeit zu der Werkstück gegebenen Winkel erreicht
%   btAng:      gegebener Winkel des Bauteils
%   feedrate:   Vorschub der Werkst-Achse
%   n:          Drehzahl des Werkzeugs
t = abs((btAng)/(feedrate * n));
end

