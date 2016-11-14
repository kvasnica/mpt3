function test_polyunion_contains_04_pass
%
% overlaps, point not contained
%

P = ExamplePoly.randVrep('d',3);
Q = P.intersect(Polyhedron('lb',[-1;-2;-3],'ub',[1;2;3]));

T = Q.triangulate;
T = T+0.1*ExamplePoly.randVrep('d',3);

U = PolyUnion('Set',T,'FullDim',true,'Convex',true,'Overlaps',true,'Bounded',true);

[isin,inwhich,closest] = U.contains([1;2;3]+rand(3,1));

if isin
    error('The point should be outside');
end

if isempty(closest)
    error('The closest point should not be empty.');
end

if ~isempty(inwhich)
    error('Inwhich should be empty here because the point is outside.');
end

end
