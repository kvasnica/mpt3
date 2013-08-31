function  test_polyhedron_project_06_pass
%
% infeasible polyhedron
%

P = Polyhedron('A',randn(27,2),'b',randn(27,1));

while ~P.isEmptySet
    P = Polyhedron('A',randn(27,2),'b',randn(27,1));
end

d = P.project([1; 2]);

if ~isempty(d.dist)
    error('Must be empty here.');
end
    


end
