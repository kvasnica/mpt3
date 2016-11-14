function test_polyhedron_setdiff_17_pass
%
% two identical low-dimensional polyhedra
%

P = ExamplePoly.randHrep('d',3,'ne',1);

Q = Polyhedron(P);

T = P\Q;

if numel(T)~=1
    error('Must be one empty polyhedron at the output.');
end
if ~T.isEmptySet
    error('The output is empty set.');
end

end