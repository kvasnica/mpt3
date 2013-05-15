function test_polyhedron_meshgrid_01_pass
%
% simple H-polyhedron
%

P = ExamplePoly.randVrep;

% do not provide grid
[X,Y]=P.meshGrid;

Xn = X(:);
Yn = Y(:);
Xn(isnan(Xn))=[];
Yn(isnan(Yn))=[];

if any(~P.contains([Xn,Yn]))
    error('Wrong default value.');
end


end