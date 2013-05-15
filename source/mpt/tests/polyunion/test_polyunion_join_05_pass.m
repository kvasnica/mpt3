function test_polyunion_join_05_pass
%
% check of boundedness
%

for i=1:10    
    % can be unbounded
   P(i) = ExamplePoly.randHrep('d',5);
end
% bounded
for i=1:5
   Q(i) = ExamplePoly.randVrep('d',5);
end
% bounded
for i=1:4
   H(i) = ExamplePoly.randVrep('d',5);
end

U(1) = PolyUnion('Set',P,'Bounded',false);
U(2) = PolyUnion(Q);
U(3) = PolyUnion(H);

Un = U.join;

if Un.Num~=19
    error('19 sets expected.')
end

end
