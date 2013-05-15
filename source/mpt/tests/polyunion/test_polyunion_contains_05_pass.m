function test_polyunion_contains_05_pass
%
% H-V rep
%

for i=1:50
    P(i) = ExamplePoly.randVrep('d',2);
end

for i=1:50
    Q(i) = ExamplePoly.randHrep('d',2);
end


U1 = PolyUnion('Set',P);
U2 = PolyUnion('Set',Q);

t0 = cputime;
[isin1,inwhich1,closest1] = U1.contains(5*randn(1,2),1);
t1 = cputime -t0;
[isin2,inwhich2,closest2] = U1.contains(5*randn(1,2),1);
t2 = cputime -t1;

end
