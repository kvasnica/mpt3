function test_polyunion_add_17_pass
%
% unly full-dim
%

P(1)=ExamplePoly.randVrep;
P(2)=ExamplePoly.randVrep;

PU = PolyUnion('Set',P,'Bounded',true,'FullDim',true);

Q(1) = ExamplePoly.randHrep;
Q(2) = Polyhedron('He',[1 -1 0],'lb',zeros(1,2));

% if Q is added, the convexity remains
[worked, msg] = run_in_caller('PU.add(Q); ');
assert(~worked);
asserterrmsg(msg,'The polyhedra cannot be added because it conflicts with "Bounded, Fulldim" property.');


end
