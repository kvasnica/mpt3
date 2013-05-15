function test_polyhedron_convexHull_22_pass
%
% testing indices of removed rows with some zero rows
%

global MPTOPTIONS

for i=1:50
    A = [randn(54,19); zeros(5,19); randn(37,19)];
    b = 5*randn(54+5+37,1);
    P = Polyhedron(A,b);    
    Hold = P.H;
    [~,T] = P.minHRep();
    H = Hold(~T.I,:);
    if norm(H-T.H)>MPTOPTIONS.rel_tol
        error('H rep is not the same');
    end
end

                     
end
