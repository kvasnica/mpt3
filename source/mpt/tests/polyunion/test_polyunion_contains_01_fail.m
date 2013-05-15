function test_polyunion_contains_01_fail
%
% wrong value of  the vector
%

for i=1:5
    P(i) = ExamplePoly.randHrep('d',10);
end

U = PolyUnion('Set',P,'FullDim',true);

x = zeros(1,10);
x(1)=NaN;
[isin,inwhich,closest] = U.contains( );

end
