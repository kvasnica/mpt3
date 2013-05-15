function test_polyunion_join_04_pass
%
% check of boundedness
%

for i=1:10    
   P(i) = ExamplePoly.randHrep('d',5);
   while ~P(i).isBounded
       P(i) = ExamplePoly.randHrep('d',5);
   end
end
% bounded
for i=1:5
   Q(i) = ExamplePoly.randVrep('d',5);
end
% bounded
for i=1:4
   H(i) = ExamplePoly.randVrep('d',5);
end

U(1) = PolyUnion('Set',P,'Bounded',true);
U(2) = PolyUnion(Q);
U(3) = PolyUnion(H);

Un = U.join;

if Un.Num~=19
    error('19 sets expected.')
end

end
