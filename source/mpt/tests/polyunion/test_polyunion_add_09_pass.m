function test_polyunion_add_09_pass
%
% non-convex, non-bounded
%

P(1)=ExamplePoly.randHrep;
P(2)=ExamplePoly.randHrep;

Q = P+ExamplePoly.randHrep;

% can add anything
PU = PolyUnion('Set',P,'Convex',false,'Connected',false);

% add Q
PU.add(Q);


end