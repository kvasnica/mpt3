function test_polyhedron_isempty_05_pass
%
% isempty test
% 
% 

P = Polyhedron;
if ~isEmptySet(P+2*P-0*P)
    error('Given polyhedron object should be empty');
end

end
