function test_polyunion_contains_03_pass
%
% overlaps
%

P = ExamplePoly.randVrep('d',2);

T = P.triangulate;
T = T+0.1*ExamplePoly.randVrep;

U = PolyUnion('Set',T,'FullDim',true,'Convex',true,'Overlaps',true,'Bounded',true);

x = 0.01*randn(1,2);
% the point must be a column vector
x = x(:);

[isin,inwhich,closest] = U.contains(x);

if ~isin
    error('Empty set');
end

end
