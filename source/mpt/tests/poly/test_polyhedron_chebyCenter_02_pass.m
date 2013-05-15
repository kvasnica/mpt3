function test_polyhedron_chebyCenter_02_pass
%
% test array of polyhedra
%

for i=1:10,
    P(i) = ExamplePoly.randHrep; 
end

r=P.chebyCenter;

if ~isa(r,'cell')
    if length(r)~=10
        error('Result must be a cell with 10 elements.');
    end
end

end