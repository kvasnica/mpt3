function test_polyunion_eq_09_pass
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

[worked, msg] = run_in_caller('ts = (U == Un); ');
assert(~worked);
asserterrmsg(msg,'Unions must have the same dimension.');


end