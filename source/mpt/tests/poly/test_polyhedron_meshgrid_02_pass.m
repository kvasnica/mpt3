function test_polyhedron_meshgrid_02_pass
%
% array V-H-polyhedron
%

P(1) = ExamplePoly.randVrep;
P(2) = ExamplePoly.randHrep;

% do not provide grid
[X,Y]=P.meshGrid;

for i=1:2
    Xn = X{i}(:);
    Yn = Y{i}(:);
    Xn(isnan(Xn))=[];
    Yn(isnan(Yn))=[];
    
    if any(~P(i).contains([Xn,Yn]'))
        error('Wrong default value.');
    end
end

end
