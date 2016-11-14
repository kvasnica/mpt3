function test_polyunion_add_14_pass
%
% two connected polyhedra, the third is not connected
%

P(1)=Polyhedron('lb',[0;0],'ub',[1;1]);
P(2)=Polyhedron('lb',[1;0],'ub',[2;1]);

PU = PolyUnion('set',P,'convex',true,'overlaps',false);

Q=Polyhedron('V',[3 0;3 1; 4 0]);

% if Q is added, the convexity remains
[worked, msg] = run_in_caller('PU.add(Q); ');
assert(~worked);
asserterrmsg(msg,'The polyhedra cannot be added because it conflicts with "Convex, Connected" property.');


end