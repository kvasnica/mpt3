function test_bintreeunion_toc_02_pass
% PWQ function

% make sure we always delete temporary files upon exiting
c = onCleanup(@(x) cleanfiles('mpt_getInput'));

HV = [   -5.18475168119689           22.493817959257
          15.6047246941317          13.5590032733746
         -24.2799932479578          3.22463275898094
          19.4479290185209          3.36041779867528
          21.5562105071849         -14.8646682206045
         -9.10818827615272         -13.7739873437905];
H = Polyhedron(HV);     
     
V{1} = [
          15.6047246941318          13.5590032733746
          19.4479290185209          3.36041779867529
                         0                         0];
V{2} = [
         -24.2799932479578          3.22463275898094
         -9.10818827615273         -13.7739873437905
                         0                         0];

V{3} = [
         -24.2799932479578          3.22463275898094
         -5.18475168119689           22.493817959257
                         0                         0];

V{4} = [
          -5.1847516811969           22.493817959257
          15.6047246941317          13.5590032733746
                         0                         0];

V{5} = [
          -9.1081882761527         -13.7739873437905
          21.5562105071849         -14.8646682206045
                         0                         0];

V{6} = [
          19.4479290185209          3.36041779867529
          21.5562105071849         -14.8646682206045
                         0                         0];

for i=1:6
    P(i) = Polyhedron(V{i});
    P(i).addFunction(QuadFunction(randn(2),randn(1,2),randn(1)),'f');
    P(i).addFunction(QuadFunction(randn(2),randn(1,2),randn(1)),'q');
end

U = PolyUnion('Set',P,'Bounded',true,'Connected',true,'Overlaps',false,'Convex',true);

U.toC('f');
mex('mpt_getInput_mex.c');

x = grid(H,20);

for i=1:size(x,1)
   u1 = U.feval(x(i,:)','f','tiebreak',@(x)0);
   u2 = mpt_getInput_mex(x(i,:)');
   if norm(u1-u2,Inf)>1e-6
       error('The function value does not hold for the row %d.',i);
   end        
end
                            
end

function cleanfiles(fname)

clear('functions');
delete([fname,'_mex.',mexext]);
delete([fname,'.c']);
delete([fname,'_mex.c']);

end