function test_polyunion_add_16_pass
%
% bounded polyhedron + unbounded polyhedron
%

P=ExamplePoly.randVrep;

PU = PolyUnion('Set',P,'Bounded',true);

Q(1) = ExamplePoly.randHrep;
Q(2) = Polyhedron('He',rand(1,3));

% if Q is added, the convexity remains
[worked, msg] = run_in_caller('PU.add(Q); ');
assert(~worked);
asserterrmsg(msg,'The polyhedra cannot be added because it conflicts with "Bounded" property.');


end