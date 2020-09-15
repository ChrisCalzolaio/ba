function sAprx = sineApprox( x )

k1 = 1.27323954;
k2 = 0.405284735;

sAprx = k1 * x - sign(x) .* k2 .* x.^2;

end