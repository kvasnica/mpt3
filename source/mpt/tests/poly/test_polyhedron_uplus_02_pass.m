function test_polyhedron_uplus_02_pass
%
% V-rep
%

P = ExamplePoly.randVrep;

T1 = P;

T2 = +P;

if T1~=P || T2~=P
    error('Polyhedra must be the same.');
end

end