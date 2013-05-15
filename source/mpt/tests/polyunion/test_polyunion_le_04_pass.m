function test_polyunion_le_04_pass
% test rejection of arrays of polyunions

P = Polyhedron('lb', -1, 'ub', 1);
U1 = PolyUnion(P);
U2 = PolyUnion(P);
U3 = PolyUnion(P);

[worked, msg] = run_in_caller('[U1 U2]<=U3');
assert(~worked);
assert(~isempty(strfind(msg, 'This method does not support arrays. Use the forEach() method.')));

[worked, msg] = run_in_caller('[U1 U2]>=U3');
assert(~worked);
assert(~isempty(strfind(msg, 'This method does not support arrays. Use the forEach() method.')));

end
