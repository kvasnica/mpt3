function test_union_contains_05_pass
%
% empty union 
%

for i=1:5
    P(i) = Polyhedron;
end

U = Union('Set',P);

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
