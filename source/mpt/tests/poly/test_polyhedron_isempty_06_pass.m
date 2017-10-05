function test_polyhedron_isempty_06_pass
%
% isempty test
% 
% 

% too many equalities
P = Polyhedron('H',[1 1],'He',[0.5 3;0.4 5;0.6 7]);
if ~isEmptySet(P)
    error('Given polyhedron object should be empty');
end

end
