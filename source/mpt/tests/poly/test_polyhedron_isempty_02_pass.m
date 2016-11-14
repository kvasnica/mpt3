function test_polyhedron_isempty_02_pass
%
% isempty test
% 
% 

Q = Polyhedron;
P = 2*Q;
if ~all(isEmptySet([P;Q]))
    error('Given polyhedron object should be empty');
end
