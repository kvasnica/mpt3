function test_polyunion_eq_04_pass
%
% two exact sets
%

for i=1:5
    P(i) = ExamplePoly.randHrep;
end

U1 = PolyUnion(P);
U2 = PolyUnion(fliplr(P));

ts = (U1 == U2);

if ~ts
    error('Must be equal.');
end

tn = (U2 == U1);
if ~tn
    error('Must be equal.');
end

end