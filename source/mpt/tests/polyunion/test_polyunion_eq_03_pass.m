function test_polyunion_eq_03_pass
%
% one set - empty
%

U1 = PolyUnion(ExamplePoly.randHrep);
U2 = PolyUnion;

ts = (U1 == U2);

if ts
    error('Not equal.');
end

tn = (U2 == U1);
if tn
    error('Not equal.');
end

end