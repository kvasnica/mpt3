function test_polyhedron_convexHull_21_pass
%
% testing indices of removed rows
%

global MPTOPTIONS

for i=1:50
    P = Polyhedron(randn(54,19),5*rand(54,1));
    Hold = P.H;
    [~,T] = P.minHRep();
    H = Hold(~T.I,:);
    if norm(H-T.H)>MPTOPTIONS.rel_tol
        error('H rep is not the same');
    end
end

                     
end
