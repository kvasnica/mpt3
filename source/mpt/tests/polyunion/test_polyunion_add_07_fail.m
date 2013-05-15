function test_polyunion_add_07_fail
%
% non-convex, non-bounded, full-dim
%

P(1)=ExamplePoly.randHrep;
P(2)=ExamplePoly.randHrep;

Q = ExamplePoly.randHrep('ne',1);

PU = PolyUnion('Set',P,'Convex',false,'Connected',false,'FullDim',true);

% Q must be full-dim
PU.add(Q);


end