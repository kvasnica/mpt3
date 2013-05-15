function test_polyunion_eq_03_fail
%
% different dimension
%

for i=1:4
    P(i) = ExamplePoly.randHrep;
end
for i=1:2
    Q(i) = ExamplePoly.randVrep('d',3);
end


U1 = PolyUnion('Set',P,'Overlaps',true);
U2 = PolyUnion('Set',Q,'FullDim',true,'Bounded',true);

ts = U1.eq(U2);


end