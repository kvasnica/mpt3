function test_polyhedron_homogenize_05_pass
%
% array of H-V polyhedra
%

P(1) = Polyhedron(randn(6,4),4*rand(6,1));
P(2) = Polyhedron(randn(8,5))+10*randn(5,1);

R = P.homogenize;

for i=1:2
    
    xc = P(i).interiorPoint;
    % 1D polyhedron in parameter
    if ~P(i).hasHRep
        P(i).minHRep();
    end
    T = Polyhedron(-P(i).b,-P(i).A*xc.x);
    B = T.outerApprox;
    % compute the lower bound on parameter
    t = min(B.Internal.lb,B.Internal.ub);
    
    x = [xc.x;t];
    if ~R(i).contains(x);
        error('R must contain x.');
    end
    
end

end
