function test_polyhedron_setdiff_13_pass
%
% H-V polyhedra
%

P = ExamplePoly.randHrep;

Q = ExamplePoly.randVrep;

R = P\Q;
R(R.isEmptySet)=[];

for i=1:numel(R)
    if R(i)==P || R(i)==Q
        error('R should be different from P or Q.');
    end
end

end