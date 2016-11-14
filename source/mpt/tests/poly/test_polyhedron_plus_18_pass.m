function test_polyhedron_plus_18_pass
% tests plus(A, B, method)

A = Polyhedron.unitBox(2);
B = Polyhedron.unitBox(2);

% default projection method should not be pLP
T = evalc('R = A+B;');
% mpt_plcp must NOT been called:
assert(isempty(strfind(T, 'mpt_plcp')));

% explicitly ask for the pLP projection method

% create polytopes again to make sure we have the same representation as
% above 
A = Polyhedron.unitBox(2); 
B = Polyhedron.unitBox(2);
method = 'mplp';
T = evalc('Q = plus(A, B, method);');
% mpt_plcp must have been called:
% Note that after ebfb2a3a9f14 Polyhedron/projection is silent
assert(isempty(strfind(T, 'mpt_plcp')));

assert(R==Q);

end
