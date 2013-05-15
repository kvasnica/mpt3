function test_polyunion_add_06_fail
%
% only connected
%

P(1)=ExamplePoly.randHrep;
while ~P(1).isBounded
    P(1)=ExamplePoly.randHrep;
end
P(2)=-P(1);

Q = P+[5;5];

PU = PolyUnion('Set',P,'Connected',true);

% add Q
PU.add(Q);


end