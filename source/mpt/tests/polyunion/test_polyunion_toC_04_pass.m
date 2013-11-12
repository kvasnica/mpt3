function test_polyunion_toC_04_pass
%
% 1D PWA case, unbounded, no-overlaps
%

P(1) = Polyhedron('ub',-1);
P(2) = Polyhedron('lb',-1,'ub',1);
P(3) = Polyhedron('lb',1);
% add function
for i=1:3
    P(i).addFunction(AffFunction(randn(1),randn(1)),'alpha');
end
U = PolyUnion('Set',P,'Bounded',false,'Overlaps',false);

U.toC('alpha')

onCleanup(@cleanfiles);
mex('mpt_getInput_mex.c')

for i=-5:0.1:5
   u1 = U.feval(i,'alpha','tiebreak',@(x)0);
   u2 = mpt_getInput_mex(i);
   if norm(u1-u2,Inf)>1e-6
       error('The function value does not hold for the point %f.',i);
   end        
end

end

function cleanfiles

clear('functions');
delete(['mpt_getInput_mex.',mexext]);
delete('mpt_getInput.c');
delete('mpt_getInput_mex.c');

end