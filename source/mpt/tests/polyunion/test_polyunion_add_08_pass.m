function test_polyunion_add_08_pass
%
% only unbounded 
%

% these are unbounded
P(1)=Polyhedron('lb',[0;1]);
P(2)=Polyhedron('R',[0,-1]);

PU = PolyUnion('Set',P,'Bounded',false);

% add Q which is unbounded too
Q = Polyhedron('Ae',randn(1,2),'be',1);
PU.add(Q);


end