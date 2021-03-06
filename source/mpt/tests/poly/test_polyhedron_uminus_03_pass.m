function test_polyhedron_uminus_03_pass
%
% [H-V] array, 4D
%

H = [  -0.5102    0.1415    1.2176    0.6863   10.0000
    1.3935    1.6939    0.3031    0.4351   10.0000
    0.9400    0.6558    0.5089    0.0375   10.0000
   -0.6356    1.8797    1.5367   -0.4811   10.0000
   -0.3076    0.2362   -0.7979    1.8930   10.0000
   -0.1597    0.8513   -0.5480    0.2826   10.0000
    0.2500   -0.3336   -0.4847    0.7824   10.0000
    0.6136   -0.7237   -2.2882    0.8566   10.0000
    0.9094   -0.0318   -1.2239    0.0373   10.0000];
He = [    0.7691    0.3650    0.1612    0.4992         0];

V = [ -11.2818  -26.4149   -4.8302
  -10.2281  -12.7260   10.7100
   -4.5141   26.5086  -12.0623
   -7.9502    3.5970  -14.7393
   -2.1480    0.4128   23.4172
    1.7301  -10.3348   14.2913
  -26.6336    7.0728  -21.4154
  -21.7972    6.2777  -12.6430
  -12.5615  -15.2482   10.1189
   -4.2485    5.1239   -8.1470];
R = [   0.9414    0.8137   -0.020];
P(1) = Polyhedron('H',H,'He',He);
P(2) = Polyhedron('V',V,'R',R);

T = -P;

R = -T;

for i=1:2
    if R(i)~=P(i)
        error('Polyhedra must be the same.');
    end
end
end