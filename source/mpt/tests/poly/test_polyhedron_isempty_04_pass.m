function test_polyhedron_isempty_04_pass
%
% isempty test
% 
% 

P = Polyhedron(randn(5,6));
if ~isEmptySet(P-1.2*P)
    error('Given polyhedron object should be empty');
end

end
