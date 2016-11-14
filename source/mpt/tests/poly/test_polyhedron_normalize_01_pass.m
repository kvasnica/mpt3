function test_polyhedron_normalize_01_pass
%
% empty polyhedron -no change
%

P = Polyhedron;
P.normalize;
if ~isempty(P.H)
    error('Must be empty.');
end

end