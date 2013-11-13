function test_polyunion_toC_06_pass
%
% 3D PWA/PWQ case, bounded, overlaps, tie-breaking
%

H1 = [    -9.52974690953379         -15.3218960296576          18.1358213090433
          15.9702632391116         -14.7384649800853        -0.570807159144771
          5.27470251141925        -0.416630742964495          13.0936207782942
          8.54202301151847         -6.15507335128413         -10.4473584840963
          13.4184652204595          13.1415480877584         -3.48266810335265
         -24.9953344192971         -14.5506658248224          14.1256116072929
         -1.67559322169704         -17.4234922059761           15.023829285828
          7.17253725490156          11.9293039852572           4.9075227190337
         -13.0485163873161         -8.02823098305938         -5.86126139576403
         -9.60644804719149          8.28387265991092          11.3930626903051
         -16.3380239579279          2.17738348381478          -4.2586784557171
          7.61200281866834         -19.0924490126272          6.36139891402967
          11.9330715170307         -5.36821821287498          7.93178081389574
          16.3205721592088         -3.02032298446366         -8.98377114100747];

H2 = [    0.113541711008201         -14.9691887644755         -18.3014932210345
          29.4909254131559         -4.04181545031202          9.49274703601312
         -0.46879399538193         -8.66485025359611          22.8782860567075
          26.8302551077173         -4.21846780441972            1.667276633497
         -11.4669068617904         -9.42666324280616         -21.5649075169974
          5.52998745466265          13.4188371725795          16.8939930742667
          -10.764584090925         -9.88434712294864          12.8228074709257
          10.3063958408679          18.1794268764347         -5.82630964347252
          6.52124811269931         -14.5174071991738          7.79451472862399
          -22.751015423474          1.60227276748647        -0.388237009280517
         -6.54768851858015         -14.5904186908361          14.2296061879913];     

P1 = Polyhedron(H1);
P2 = Polyhedron(H2);
     
T1 = P1.triangulate;
T2 = P2.triangulate;

% add PWA/PWQ function
for i=1:numel(T1)
    T1(i).addFunction(QuadFunction(randn(3),randn(1,3),randn(1)),'q');
    T1(i).addFunction(AffFunction(randn(5,3),randn(5,1)),'f');
end
for i=1:numel(T2)
    T2(i).addFunction(QuadFunction(randn(3),randn(1,3),randn(1)),'q');
    T2(i).addFunction(AffFunction(randn(5,3),randn(5,1)),'f');
end

U(1) = PolyUnion('Set',T1,'Overlaps',false,'Bounded',true,'Connected',true,'Convex',true);
U(2) = PolyUnion('Set',T2,'Overlaps',false,'Bounded',true,'Connected',true,'Convex',true);


fname = 'test_polyunion_toC_06';
U.toC('f',fname,'q');

onCleanup(@(x)cleanfiles(fname));
mex([fname,'_mex.c'])

% grid bounding box
B = outerApprox(Polyhedron([H1;H2]));
x = B.grid(10);

for i=1:size(x,1)
   u1 = U.feval(x(i,:)','f','tiebreak','q');
   if ~isnan(u1)
       u2 = eval([fname,'_mex(x(i,:)'')']);
       if norm(u1-u2,Inf)>1e-6
           error('The function value does not hold for the point %f.',i);
       end
   end
end

end

function cleanfiles(fname)

clear('functions');
delete([fname,'_mex.',mexext]);
delete([fname,'.c']);
delete([fname,'_mex.c']);

end