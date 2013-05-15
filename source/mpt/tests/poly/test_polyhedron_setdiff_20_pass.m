function test_polyhedron_setdiff_20_pass
% test the "noconstruction" flag

A = [1 -4.0217906504221;-1 2.62705876174804;-6.2534305158641 -1;-1 1.45242644876337;-1.30946115541203 -1;1 1.40715050811825;1.47339887063666 1;1 -2.79419884295457];
b = [7.07226001300678;4.0036849865292;7.78526230532414;2.45589255025793;2.48316663227603;2.38448288335533;2.54399261228781;5.50226104343264];
P = Polyhedron(A, b);
T = P.triangulate;
assert(length(T)==6);

% T==P, therefore T\P=0 and P\T=0
t=Polyhedron(T); p=Polyhedron(P);
d1 = t\p;
t=Polyhedron(T); p=Polyhedron(P);
d2 = p\t;
assert(d1.isEmptySet);
assert(d2.isEmptySet);

% same result even when using the special flag
flag = true;
t=Polyhedron(T); p=Polyhedron(P);
d1 = mldivide(t, p, flag);
t=Polyhedron(T); p=Polyhedron(P);
d2 = mldivide(p, t, flag);
assert(d1.isEmptySet);
assert(~d2.isFullDim);

% now a case where T~=P
T = T(1:4);
t=Polyhedron(T); p=Polyhedron(P);
d1 = t\p;
t=Polyhedron(T); p=Polyhedron(P);
d2 = p\t;
assert(d1.isEmptySet);
assert(d2.isFullDim);

% same result even when using the special flag
flag = true;
t=Polyhedron(T); p=Polyhedron(P);
d1 = mldivide(t, p, flag);
t=Polyhedron(T); p=Polyhedron(P);
d2 = mldivide(p, t, flag);
assert(d1.isEmptySet);
assert(any(d2.isFullDim));
