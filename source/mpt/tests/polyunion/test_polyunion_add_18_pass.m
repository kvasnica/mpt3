function test_polyunion_add_18_pass
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
[worked, msg] = run_in_caller('PU.add(Q); ');
assert(~worked);
asserterrmsg(msg,'The polyhedra cannot be added because it conflicts with "Connected" property.');


end