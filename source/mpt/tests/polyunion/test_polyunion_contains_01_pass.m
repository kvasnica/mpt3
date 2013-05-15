function test_polyunion_contains_01_pass
%
% empty polyunion 
%

for i=1:5
    P(i) = Polyhedron;
end

U = PolyUnion('Set',P,'FullDim',true);

[isin,inwhich,closest] = U.contains([]);

if isin
    error('Empty set');
end
if ~isempty(inwhich)
    error('Empty set');
end
if ~isempty(closest)
    error('Empty set');
end

end
