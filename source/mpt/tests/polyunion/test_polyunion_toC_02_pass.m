function test_polyunion_toC_02_pass
%
% testing wrong syntax - only PWA/PWQ functions are allowed
%

P(1) = Polyhedron('ub',-1);
P(2) = Polyhedron('lb',-1,'ub',1);
P(3) = Polyhedron('lb',1);

for i=1:3
    P(i).addFunction(Function(@(x)x),'f');
end
U = PolyUnion('Set',P,'Bounded',false,'Overlaps',false);

% only PWA/PWQ functions are allowed
[~,msg] = run_in_caller('U.toC(''f'');');
asserterrmsg(msg,'Only quadratic and affine functions are supported');

for i=1:3
    P(i).addFunction(AffFunction(rand(1),rand(1)),'g');
end
Un = PolyUnion('Set',P,'Bounded',false,'Overlaps',false);

% only PWA/PWQ functions are allowed
[~,msg] = run_in_caller('Un.toC(''g'',''file'',''f'');');
asserterrmsg(msg,'Only quadratic and affine tie-break functions are supported');


end
