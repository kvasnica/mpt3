function test_polyunion_add_15_pass
%
% two connected & bounded polyhedra, add unbounded one
%

P(1)=ExamplePoly.randHrep;
P(2)=ExamplePoly.randVrep;

while any(~P.isBounded)
    P(1)=ExamplePoly.randHrep;
    P(2)=ExamplePoly.randVrep;
end

PU = PolyUnion('Set',P,'Connected',true,'Bounded',true);

Q(1) = ExamplePoly.randHrep;
Q(2) = Polyhedron('He',rand(1,3));

% if Q is added, the convexity remains
[worked, msg] = run_in_caller('PU.add(Q); ');
assert(~worked);
asserterrmsg(msg,'The polyhedra cannot be added because it conflicts with "Bounded" property.');


end