function test_polyunion_add_19_pass
%
% non-convex, non-bounded, full-dim
%

P(1)=ExamplePoly.randHrep;
P(2)=ExamplePoly.randHrep;

Q = ExamplePoly.randHrep('ne',1);

PU = PolyUnion('Set',P,'Convex',false,'Connected',false,'FullDim',true);

% Q must be full-dim
[worked, msg] = run_in_caller('PU.add(Q); ');
assert(~worked);
asserterrmsg(msg,'The polyhedra cannot be added because it conflicts with "Fulldim" property.');


end