function test_polyunion_contains_01_pass
%
% empty polyunion 
%

for i=1:5
    P(i) = Polyhedron;
end

U = PolyUnion('Set',P,'FullDim',true);
[isin, inwhich, closest] = U.contains([]);
assert(isempty(isin));
assert(isempty(inwhich));
assert(isempty(closest));

% empty array
U = U([]);
[isin, inwhich, closest] = U.contains([]);
assert(isempty(isin));
assert(isempty(inwhich));
assert(isempty(closest));

end
