function test_polyhedron_homogenize_03_pass
%
% H- polyhedron
%

P = Polyhedron(randn(18,9),4*rand(18,1));

R = P.homogenize;

xc = P.interiorPoint;

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