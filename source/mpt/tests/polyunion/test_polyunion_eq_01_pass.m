function test_polyunion_eq_01_pass
%
% empty polyunion
%

U1 = PolyUnion;
U2 = PolyUnion;

ts = (U1 == U2);

if ~ts
    error('Empty arrays should be equal.');
end

U1n = PolyUnion(ExamplePoly.randHrep);
U2n = PolyUnion;

tsn = U1n==U2n;

if tsn
    error('Different sets are not equal');
end
end