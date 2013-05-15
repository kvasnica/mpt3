function test_polyunion_copy_04_pass
%
% copy two sets including functions, compute hull
%

P(1) = ExamplePoly.randHrep;
P(2) = ExamplePoly.randVrep;
P.addFunction(Function(@(x)x),'a');
P.addFunction(Function(@(x)x.^2),'b');
U = PolyUnion(P);
Un = U.copy;

% compute convexHull
H=U.convexHull;

% Un must not have bounding box values present
if isfield(Un.Internal,'convexHull')
    error('The field "convexHull" must not be here because it is a new copy.')
end

end