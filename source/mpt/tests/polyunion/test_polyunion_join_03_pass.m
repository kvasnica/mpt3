function test_polyunion_join_03_pass
%
% add without checking of properties
%

for i=1:10
   P(i) = ExamplePoly.randHrep('d',5);
end
for i=1:5
   Q(i) = ExamplePoly.randHrep('d',5);
end
for i=1:4
   H(i) = ExamplePoly.randHrep('d',5);
end


U(1) = PolyUnion(P);
U(2) = PolyUnion(Q);
U(3) = PolyUnion(H);

Un = U.join;

if Un.Num~=19
    error('19 sets expected.')
end

end
