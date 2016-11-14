function test_polyhedron_chebyCenter_02_pass
%
% test array of polyhedra
%

for i=1:10,
    P(i) = ExamplePoly.randHrep; 
end

r=P.chebyCenter;
assert(isstruct(r));
assert(numel(r)==numel(P));
assert(isfield(r(1), 'exitflag'));
assert(isfield(r(1), 'x'));
assert(isfield(r(1), 'r'));

end
