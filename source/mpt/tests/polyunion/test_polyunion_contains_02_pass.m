function test_polyunion_contains_02_pass
%
% polycomplex
%

P = ExamplePoly.randVrep('d',3)+[1;2;3];

T = P.triangulate;

U = PolyUnion('Set',T,'FullDim',true,'Convex',true,'Overlaps',false,'Bounded',true);

x = 0.01*randn(1,3)+[1,2,3];
% the point must be a column vector
x = x(:);
[isin,inwhich,closest] = U.contains(x);

if ~isin
    error('The point should be inside.');
end
if numel(inwhich)>1
    error('Here should be only one index returned because it is non-overlapping partition.');
end

end
