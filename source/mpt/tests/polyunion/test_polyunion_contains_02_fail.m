function test_polyunion_contains_02_fail
%
% wrong dimension of the vector
%

for i=1:5
    P(i) = ExamplePoly.randHrep('d',10);
end

U = PolyUnion('Set',P,'FullDim',true);

[isin,inwhich,closest] = U.contains( [1;2;-3]);

end
