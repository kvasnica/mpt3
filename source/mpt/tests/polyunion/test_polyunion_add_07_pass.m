function test_polyunion_add_07_pass
%
% only full-dim
%

P(1)=ExamplePoly.randVrep;
P(2)=ExamplePoly.randVrep;

PU = PolyUnion('Set',P,'Bounded',true,'FullDim',true);

Q = ExamplePoly.randHrep;

% add Q
PU.add(Q);


end