function test_polyhedron_isempty_03_pass
%
% isempty test
% 
% 

Q = Polyhedron;
P = Polyhedron(randn(5,6));
t = isEmptySet([Q,P]);
if ~t(1)
    error('Given polyhedron object should be empty');
end

end
