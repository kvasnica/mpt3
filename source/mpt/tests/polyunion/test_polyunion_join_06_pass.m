function test_polyunion_join_06_pass
%
% check of full-dimensionality
%

% full-dim
for i=1:10    
   P(i) = ExamplePoly.randHrep('d',5);
end
% bounded, full-dim
for i=1:5
   Q(i) = ExamplePoly.randVrep('d',5);
end
% bounded, full-dim
for i=1:4
   H(i) = ExamplePoly.randVrep('d',5);
end

U(1) = PolyUnion('Set',P,'Bounded',false,'FullDim',true);
U(2) = PolyUnion('Set',Q);
U(3) = PolyUnion(H);

Un = U.join;

if Un.Num~=19
    error('19 sets expected.')
end

end
