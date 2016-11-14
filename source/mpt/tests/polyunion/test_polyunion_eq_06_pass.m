function test_polyunion_eq_06_pass
%
% lower-dimensional union
%

for i=1:4
    P(i) = ExamplePoly.randHrep('d',3,'ne',1);
end
for i=1:2
    Q(i) = ExamplePoly.randVrep('d',3,'nr',1);
end


U1 = PolyUnion('Set',P,'Overlaps',true,'FullDim',false);
U2 = PolyUnion('Set',Q,'FullDim',true,'Bounded',false);

ts = U1.eq(U2);

if ts
    error('Sets are not equal');
end

end