function test_polyunion_toC_07_pass
%
% 3D PWQ/PWQ case, bounded, overlaps, tie-breaking, single precision
%

global precision

% set single precition
settings = mptopt;
precision = settings.modules.geometry.unions.PolyUnion.toC.precision;
settings.modules.geometry.unions.PolyUnion.toC.precision = 'single';

H1 = [   -7.06194829675742         -7.37186211373274          16.3570420209551
         -10.2066339488082          1.79780786008462         -6.47794522894829
          11.3396082991119         -1.31830474073343          6.73263302065595
         0.385453320267831          8.67926893465305           12.735554991388
          2.30912726456574          13.1439188441996         -10.3981182138251
          17.3947365147502          10.9520871099522         -4.74703074987904
          6.87531804871697         -16.8015369718106         -5.02019615157079
          12.3896871529087         -8.11525459679546         -3.08886019824151
          8.98663067613683         -7.52224890813265         -8.36901296639812
         -11.5009807719898         -13.2591909291339         -6.28323893767532
         -16.2518045233166           1.3141548695608          16.7025361226242
          5.81642598985687          13.9382994884043         -15.4173010203999
          19.0249272905159          7.06213422777802         -2.72009122141325
          15.8009427643781          11.6284681064975          3.41646737617443
          9.21029054981125         -7.53687723707311          4.84366928609517];

H2 = [   -17.4191327333004         -1.80039404201094          4.01738556583068
          6.67761311057022         -20.2654769464178         -25.1419021660211
          8.98155876823478          4.08937841099143         -7.88492740881241
         -5.82693311341944         -16.8651701996981           6.8491618008259
         -1.64210931111285         -20.6171132798944          5.39770439528042
         -9.35133250760936          18.2093715528291          -3.8044894647209
           11.881074079572         -12.4913154506588          14.4305669987945
         -12.1278830751644          9.36316146764964          -8.0929881461205
          -3.8117851459639         -1.71558720044122         -14.7123105810081
         -3.61821842924756          5.68875558793755           9.7041651630749
          7.17775269897513        -0.171228886072979          15.6568859777385
          17.3608073452882          -1.3233227456277          13.5275777249813];     

P1 = Polyhedron(H1);
P2 = Polyhedron(H2);
     
T1 = P1.triangulate;
T2 = P2.triangulate;

% add PWQ/PWQ function
for i=1:numel(T1)
    T1(i).addFunction(QuadFunction(randn(3),randn(1,3),randn(1)),'a');
    T1(i).addFunction(QuadFunction(randn(3),randn(1,3),randn(1)),'b');
end
for i=1:numel(T2)
    T2(i).addFunction(QuadFunction(randn(3),randn(1,3),randn(1)),'a');
    T2(i).addFunction(QuadFunction(randn(3),randn(1,3),randn(1)),'b');
end

U(1) = PolyUnion('Set',T1,'Overlaps',false,'Bounded',true,'Connected',true,'Convex',true);
U(2) = PolyUnion('Set',T2,'Overlaps',false,'Bounded',true,'Connected',true,'Convex',true);


fname = 'test_polyunion_toC_07';
U.toC('a',fname,'b');

onCleanup(@(x)cleanfiles(fname));
mex([fname,'_mex.c'])

% grid bounding box
B = outerApprox(Polyhedron([H1;H2]));
x = B.grid(10);

for i=1:size(x,1)
   u1 = U.feval(x(i,:)','a','tiebreak','b');
   if ~isnan(u1)
       u2 = eval([fname,'_mex(x(i,:)'')']);
       % reduced tolerance due single precision (1e-4 fails)
       if norm(u1-u2,Inf)>1e-3
           error('The function value does not hold for the point %f.',i);
       end
   end
end

end

function cleanfiles(fname)

global precision

% set back the double precision
settings = mptopt;
settings.modules.geometry.unions.PolyUnion.toC.precision = precision;

clear('functions');
delete([fname,'_mex.',mexext]);
delete([fname,'.c']);
delete([fname,'_mex.c']);

end