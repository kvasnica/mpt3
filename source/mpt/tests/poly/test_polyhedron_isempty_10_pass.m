function test_polyhedron_isempty_10_pass
%
% isempty test
% 
% 

P = Polyhedron(randn(16,5));

if isEmptySet(0.5*P)
    error('Given polyhedron object should not be empty');
end

end
