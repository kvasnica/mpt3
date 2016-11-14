function test_polyunion_toC_05_pass
%
% 2D PWQ case, unbounded, no-overlaps
%

HV = [    1.0931769377487          15.1626689664595
          18.1401545028038        -0.325665091944807
          3.12023828329274          16.3599965727829
          18.0449377172419         -4.25058490610031
         -2.60250861706117         -20.2195893005179
         -21.8602161274824        -0.548861299886774
         -13.2704314952029         -11.1873200245272
          14.7020128084852         -9.93019006549601];
H = Polyhedron('V',HV);
      
V{1} = [
         -13.2704314952029         -11.1873200245272
           1.0931769377487          15.1626689664595
         -21.8602161274824        -0.548861299886774];

V{2} = [
          3.12023828329274          16.3599965727829
           1.0931769377487          15.1626689664595
          18.1401545028038        -0.325665091944807];

V{3} = [
           1.0931769377487          15.1626689664595
         -13.2704314952029         -11.1873200245272
          14.7020128084852         -9.93019006549601];

V{4} = [
          18.1401545028038        -0.325665091944807
           1.0931769377487          15.1626689664595
          14.7020128084852         -9.93019006549601];

V{5} = [
          14.7020128084852         -9.93019006549601
          18.0449377172419         -4.25058490610031
          18.1401545028038        -0.325665091944807];

V{6} = [
          14.7020128084852         -9.93019006549601
         -13.2704314952029         -11.1873200245272
         -2.60250861706117         -20.2195893005179];

P(1) = Polyhedron('V',V{1},'R',[-0.6 0]);
P(2) = Polyhedron('V',V{2},'R',[1.5 0]);     
for i=3:6
    P(i) = Polyhedron('V',V{i});     
end

% add function
for i=1:6    
    P(i).addFunction(QuadFunction(randn(2),randn(1,2),randn(1)),'q');
end
U = PolyUnion('Set',P,'Bounded',false,'Overlaps',false);

fname = 'test_polyunion_toC_05';
U.toC('q',fname);

onCleanup(@(x)cleanfiles(fname));
mex([fname,'_mex.c'])

% grid polyhedron H
x = H.grid(20);

for i=1:size(x,1)
   u1 = U.feval(x(i,:)','q','tiebreak',@(x)0);
   u2 = eval([fname,'_mex(x(i,:)'')']);
   if norm(u1-u2,Inf)>1e-6
       error('The function value does not hold for the point %f.',i);
   end        
end

end

function cleanfiles(fname)

clear('functions');
delete([fname,'_mex.',mexext]);
delete([fname,'.c']);
delete([fname,'_mex.c']);

end