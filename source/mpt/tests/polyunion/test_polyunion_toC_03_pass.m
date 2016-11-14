function test_polyunion_toC_03_pass
%
% testing wrong syntax - low-dimensional polyunions not allowed
%

for i=1:3
    P(i) = Polyhedron(randn(5,2),5*rand(5,1));
    P(i).addFunction(AffFunction(rand(2),rand(2,1)),'f');
    P(i).addFunction(AffFunction(rand(1,2),rand(1)),'tie');
end
for i=4:5
    P(i) = Polyhedron('A',randn(5,2),'b',5*rand(5,1),'Ae',randn(1,2),'be',0.5);
    P(i).addFunction(AffFunction(rand(2),rand(2,1)),'f');
    P(i).addFunction(AffFunction(rand(1,2),rand(1)),'tie');
end

U = PolyUnion('Set',P);

% only PWA/PWQ functions are allowed
[~,msg] = run_in_caller('U.toC(''f'',''file'',''tie'');');
asserterrmsg(msg,'The export to C-code works only for full-dimensional partitions');


end
