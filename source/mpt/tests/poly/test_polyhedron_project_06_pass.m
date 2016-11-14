function  test_polyhedron_project_06_pass
%
% infeasible polyhedron
%

P = Polyhedron('A',randn(27,2),'b',randn(27,1));

while ~P.isEmptySet
    P = Polyhedron('A',randn(27,2),'b',randn(27,1));
end

d = P.project([1; 2]);

% distance to an empty set is Inf by convention (issue #111)
assert(d.dist==Inf);

end
