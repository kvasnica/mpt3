function test_polyhedron_homogenize_06_pass
%
% low-dimensional array
%

P(1) = Polyhedron('A',randn(17,5),'b',6*rand(17,1),'Ae',randn(3,5),'be',zeros(3,1));

Pn = Polyhedron('A',randn(11,5),'b',6*rand(11,1),'Ae',randn(2,5),'be',zeros(2,1));
Pn.computeVRep();
P(2) = Polyhedron('R',Pn.R,'V',Pn.V);

R = P.homogenize;

for i=1:2
    
    xc = P(i).interiorPoint;
    % 1D polyhedron in parameter
    if ~P(i).hasHRep
        P(i).minHRep();
    end
    T = Polyhedron('A',-P(i).b,'b',-P(i).A*xc.x,'Ae',-P(i).be,'be',-P(i).Ae*xc.x);
    B = T.outerApprox;
    % compute the lower bound on parameter
    t = min(B.Internal.lb,B.Internal.ub);
    
    x = [xc.x;t+0.1];
    if ~R(i).contains(x);
        error('R must contain x.');
    end
    
end

end
