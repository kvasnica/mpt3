function test_polyhedron_uplus_03_pass
%
% [H,V]-array
%

P(1) = ExamplePoly.randHrep('d',5,'ne',1);
P(2) = ExamplePoly.randVrep('d',4,'nr',1);

T1 = P;

T2 = +P;

for i=1:2
    if any(T1(i)~=P(i)) || any(T2(i)~=P(i))
        error('Polyhedra must be the same.');
    end
end
end