function test_polyunion_add_13_pass
%
% add low-dim polyhedron to convex union that does not built convex union
%

P=Polyhedron('lb',[0;0],'ub',[1;1]);

PU = PolyUnion('Set',P,'Convex',true);

Q=Polyhedron('V',[1 0],'R',[0 1]);

% if Q is added, the convexity remains
[worked, msg] = run_in_caller('PU.add(Q); ');
assert(~worked);
asserterrmsg(msg,'The polyhedra cannot be added because it conflicts with "Convex" property.');


end