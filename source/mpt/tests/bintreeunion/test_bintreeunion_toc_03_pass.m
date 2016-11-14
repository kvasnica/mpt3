function test_bintreeunion_toc_03_pass
% PWA/PWQ function in 3D

% make sure we always delete temporary files upon exiting
file_name = 'test_bintreeunion_toc03';
c = onCleanup(@(x) cleanfiles(file_name));

HV = [     2.95883289332265         -26.8671545975818        -0.473958587617026
          10.7125005685966          18.5328695635616         -4.17289185198319
           15.981537614955          13.4663278115792         -9.71315923019642
         -15.7268206333714          14.2814836726647         -4.21459050071305
           1.1389028682723         -21.3403066851748          13.7601537600535
          14.8183265253314           7.2929378237356          13.4158759807549
         -8.39583456065204          5.09555979063942          6.61510443340258
         -16.7394365990269         -20.2835676048181          11.5096871013941
         -12.9507418522019           13.130730999093         -16.8967814006781
         -7.88135793022839         -17.2138304975776         -15.6138488417619
         -2.05401786644416          -3.5676782289045          14.0771465233214];    
H = Polyhedron(HV);
T = H.triangulate;
     
for i=1:numel(T)
    T(i).addFunction(QuadFunction(randn(3),randn(1,3),randn(1)),'a');
    T(i).addFunction(AffFunction(randn(10,3),randn(10,1)),'b');
end

U = PolyUnion('Set',T,'Bounded',true,'Connected',true,'Overlaps',false,'Convex',true,'FullDim',true);

% export and test PWA function
U.toC('b',file_name);
mex([file_name,'_mex.c']);

x = grid(H,10);

for i=1:size(x,1)
   u1 = U.feval(x(i,:)','b','tiebreak',@(x)0);
   u2 = eval([file_name,'_mex(x(i,:)'')']);
   if norm(u1-u2,Inf)>1e-6
       error('The PWA function value does not hold for the row %d.',i);
   end        
end

% export and test PWQ function
U.toC('a',file_name);
mex([file_name,'_mex.c']);

for i=1:size(x,1)
   u1 = U.feval(x(i,:)','a','tiebreak',@(x)0);
   u2 = eval([file_name,'_mex(x(i,:)'')']);
   if norm(u1-u2,Inf)>1e-6
       error('The PWQ function value does not hold for the row %d.',i);
   end        
end


end



function cleanfiles(fname)

clear('functions');
delete([fname,'_mex.',mexext]);
delete([fname,'.c']);
delete([fname,'_mex.c']);

end