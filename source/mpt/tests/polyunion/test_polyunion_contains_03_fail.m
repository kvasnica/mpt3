function test_polyunion_contains_03_fail
%
% wrong fastbreak
%

for i=1:5
    P(i) = ExamplePoly.randHrep;
end

U = PolyUnion(P);

[isin,inwhich,closest] = U.contains(zeros(2,1),'a');

end
