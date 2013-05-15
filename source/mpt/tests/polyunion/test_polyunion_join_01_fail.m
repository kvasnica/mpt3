function test_polyunion_join_01_fail
%
% check of full-dimensionality
%

% full-dim
for i=1:10    
   P(i) = ExamplePoly.randHrep('d',5);
end
% bounded, not-full-dim
for i=1:5
   Q(i) = ExamplePoly.randHrep('d',5,'ne',1);
end

U(1) = PolyUnion('Set',P,'Bounded',false,'FullDim',true);
U(2) = PolyUnion(Q);

Un = U.join;

end
