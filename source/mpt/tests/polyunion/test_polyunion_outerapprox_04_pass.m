function test_polyunion_outerapprox_04_pass
%
% array of polyunions
%

P(1) = ExamplePoly.randVrep('d',5);
P(2) = ExamplePoly.randHrep('d',5,'ne',2);
while any(~P.isBounded)
    P(1) = ExamplePoly.randVrep('d',5);
    P(2) = ExamplePoly.randHrep('d',5,'ne',2);
end
    
U(1) = PolyUnion(P);

Q(1) = ExamplePoly.randVrep('d',3);
Q(2) = ExamplePoly.randHrep('d',3,'ne',1);
while any(~Q.isBounded)
    Q(1) = ExamplePoly.randVrep('d',3);
    Q(2) = ExamplePoly.randHrep('d',3,'ne',1);
end

U(2) = PolyUnion(Q);

B = U.outerApprox;
H = U.forEach(@(x) x.convexHull);
Hb = H.outerApprox;

for i=1:2
    if norm(B(i).Internal.lb-Hb(i).Internal.lb,Inf)>1e-4
        error('LB do not match.');
    end
    if norm(B(i).Internal.ub-Hb(i).Internal.ub,Inf)>1e-4
        error('UB do not match.');
    end
end

end


