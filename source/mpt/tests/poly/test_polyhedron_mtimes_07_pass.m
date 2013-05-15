function test_polyhedron_mtimes_07_pass
%
% scalar - He-polyhedron
%

P = ExamplePoly.randHrep('d',8,'ne',2);

R = 0.1*P;

if ~P.contains(R)
    error('P must contain R.');
end
P.minHRep();
R.minHRep();
if norm(0.1*P.b-R.b,Inf)>1e-4
    error('Wrong scaling.');
end
if norm(0.1*P.be-R.be,Inf)>1e-4
    error('Wrong scaling.');
end

% must work also the different way
Q = ExamplePoly.randHrep('d',8,'ne',2);

S = Q*0.1;

if ~Q.contains(S)
    error('Q must contain S.');
end
Q.minHRep();
S.minHRep();
if norm(0.1*Q.b-S.b,Inf)>1e-4
    error('Wrong scaling.');
end
if norm(0.1*Q.be-S.be,Inf)>1e-4
    error('Wrong scaling.');
end

end
