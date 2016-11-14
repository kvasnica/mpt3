function test_polyhedron_uplus_01_pass
%
% H-rep
%

P = ExamplePoly.randHrep;

T1 = P;

T2 = +P;

if T1~=P || T2~=P
    error('Polyhedra must be the same.');
end

end