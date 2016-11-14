function test_polyunion_add_12_pass
% positive-fail test for PolyUnion/add

P=Polyhedron('lb',[0;0],'ub',[1;1]);
Q=Polyhedron('V',[1 0;2 1; 2 0]);

% is convex automatically
PU = PolyUnion('Set',P,'Convex',true);

% union of P and Q is not convex
[worked, msg] = run_in_caller('PU.add(Q);');
assert(~worked);
assert(~isempty(strfind(msg, 'The polyhedra cannot be added because it conflicts with "Convex" property.')));

end
