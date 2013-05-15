function test_polyunion_eq_02_fail
%
% polyunion arrays, different dimension
%

for i=1:4
    P(i) = ExamplePoly.randHrep;
end
for i=1:2
    Q(i) = ExamplePoly.randVrep('d',3);
end


U(1) = PolyUnion('Set',P,'Overlaps',true);
U(2) = PolyUnion('Set',Q,'FullDim',true,'Bounded',true);

Un = PolyUnion(P);

ts = (U == Un);


end