function test_polyunion_eq_07_pass
% compare two sets over different domains

A = [1 -4.0217906504221;-1 2.62705876174804;-6.2534305158641 -1;-1 1.45242644876337;-1.30946115541203 -1;1 1.40715050811825;1.47339887063666 1;1 -2.79419884295457];
b = [7.07226001300678;4.0036849865292;7.78526230532414;2.45589255025793;2.48316663227603;2.38448288335533;2.54399261228781;5.50226104343264];
P = Polyhedron(A, b);
T = P.triangulate;
assert(length(T)==6);

U1 = PolyUnion(P);
U2 = PolyUnion(T);
assert(U1==U2);

P = Polyhedron(A, b);
T = P.triangulate;
U1 = PolyUnion(P);
U2 = PolyUnion(T(1:4));
assert(~(U1==U2));
