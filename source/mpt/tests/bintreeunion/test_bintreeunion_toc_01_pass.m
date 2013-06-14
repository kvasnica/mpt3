function test_bintreeunion_toc_01_pass
% tests for BinTreePolyUnion/toC()

% make sure we always delete temporary files upon exiting
c = onCleanup(@() delete('st_out.c'));

P1 = Polyhedron([0 0; 3.5 1.5; 2 0; 2.5 6; 0 6]);
P2 = Polyhedron([2.5 6; 3.5 1.5; 8 6]);
P3 = Polyhedron([2 0; 7 0; 6 4]);
P4 = Polyhedron([6 4; 8 6; 10 6; 10 2; 6.5 2]);
P5 = Polyhedron([6.5 2; 7 0; 10 0; 10 2]);
P = [P1 P2 P3 P4 P5];
for i = 1:length(P)
	P(i).addFunction(AffFunction([1 1], i), 'f');
end
U = PolyUnion([P1 P2 P3 P4 P5]);
T = BinTreePolyUnion(U);

% enough inputs must be provided
[~, msg] = run_in_caller('T.toC()');
asserterrmsg(msg, 'Not enough input arguments.');
[~, msg] = run_in_caller('T.toC(''asd'')');
asserterrmsg(msg, 'Not enough input arguments.');

% the exported function must exist
[~, msg] = run_in_caller('T.toC(''bogus'', ''out.c'')');
asserterrmsg(msg, 'No such function "bogus" in the object.');

% correct settings
T.toC('f', 'st_out.c');
assert(exist('st_out.c', 'file')==2);
f = fileread('st_out.c');
asserterrmsg(f, 'Generated on');
asserterrmsg(f, 'by MPT ')

end
