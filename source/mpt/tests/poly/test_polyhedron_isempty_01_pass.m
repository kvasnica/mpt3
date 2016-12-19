function test_polyhedron_isempty_01_pass
%
% isempty test
% 
% 

if ~isEmptySet(Polyhedron)
    error('Given polyhedron object should be empty');
end

end
