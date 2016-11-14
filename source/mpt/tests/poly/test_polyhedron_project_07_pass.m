function  test_polyhedron_project_07_pass
%
% ray 
%

P = Polyhedron('R',[0 0 1]);

x = [-1;-1;-1];
d = P.project(x);

if norm(d.dist-norm(x),Inf)>1e-4
    error('Distance does not hold.');
end
    


end