function test_polyhedron_homogenize_07_pass
%
% call V-rep on H-polyhedron
%

P = ExamplePoly.randHrep('d',4,'ne',2);

R = P.homogenize('vrep');

xc = P.interiorPoint;
T = Polyhedron('A',-P.b,'b',-P.A*xc.x,'Ae',-P.be,'be',-P.Ae*xc.x);
B = T.outerApprox;
% compute the lower bound on parameter
t = min(B.Internal.lb,B.Internal.ub);
    
x = [xc.x;t];
if ~R.contains(x);
    error('R must contain x.');
end



end