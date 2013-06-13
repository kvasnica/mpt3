function test_polyunion_join_08_pass
%
% check of boundedness
%

% full-dim
for i=1:10    
   P(i) = ExamplePoly.randVrep('d',5);
end
% bounded, not-full-dim
for i=1:5
   Q(i) = ExamplePoly.randHrep('d',5,'ne',1);
end
Q(6) = ExamplePoly.randVrep('d',5,'nr',1);

U(1) = PolyUnion('Set',P,'Bounded',true,'FullDim',false);
U(2) = PolyUnion(Q);

[worked, msg] = run_in_caller('Un = U.join; ');
assert(~worked);
asserterrmsg(msg,'All unions must be bounded.');

end
