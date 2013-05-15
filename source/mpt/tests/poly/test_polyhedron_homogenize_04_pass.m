function test_polyhedron_homogenize_04_pass
%
% V- polyhedron
%

P = Polyhedron(9*randn(14,2));

R = P.homogenize;

xc = P.interiorPoint;

P.minHRep();
% 1D polyhedron in parameter
T = Polyhedron(-P.b,-P.A*xc.x);
B = T.outerApprox;
% compute the lower bound on parameter
t = min(B.Internal.lb,B.Internal.ub);

x = [xc.x;t];
if ~R.contains(x);
    error('R must contain x.');
end
    
    

end
