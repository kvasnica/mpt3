function test_polyunion_toC_01_pass
%
% testing wrong syntax 
%

P(1) = Polyhedron('ub',-1);
P(2) = Polyhedron('lb',-1,'ub',1);
P(3) = Polyhedron('lb',1);

U = PolyUnion('Set',P,'Bounded',false,'Overlaps',false);

% no function
[~,msg]=run_in_caller('U.toC('''');');
asserterrmsg(msg,'No such function "" in the object');
% wrong argument
[~,msg]=run_in_caller('U.toC(1);');
asserterrmsg(msg,'The function name must be given as a string');
[~,msg]=run_in_caller('U.toC('''',2);');
asserterrmsg(msg,'The file name must be given as a string');

% add function
for i=1:3
    P(i).addFunction(AffFunction(randn(1),randn(1)),'alpha');
end

% function with different range
Pn = Polyhedron('lb',-2,'ub',2);
Pn.addFunction(AffFunction([1;2],[1;0]),'alpha');

Un = PolyUnion('Set',[P,Pn],'Bounded',false,'Overlaps',false);
[~,msg] = run_in_caller('Un.toC(''alpha'')');
asserterrmsg(msg,'The requested function "alpha" must have the same range in all objects in the array');

% tie-break function with wrong range
for i=1:3
    P(i).addFunction(AffFunction([0;-1],[0;1]),'beta');
end
Um = PolyUnion('Set',P,'Bounded',false,'Overlaps',false);
[~,msg] = run_in_caller('Um.toC(''alpha'','''',''beta'')');
asserterrmsg(msg,'The tie-break function "beta" must be scalar valued in all objects in the array');

