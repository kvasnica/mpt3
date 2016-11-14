function test_polyunion_join_07_pass
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

[worked, msg] = run_in_caller('Un = U.join; ');
assert(~worked);
asserterrmsg(msg,'All unions must be full-dimensional.');

end
