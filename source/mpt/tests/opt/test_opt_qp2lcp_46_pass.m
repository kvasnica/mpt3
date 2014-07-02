function test_opt_qp2lcp_46_pass
%
% solve projection problem via MPLP - check transformation to LCP
% Bug reported by J. Loefberg: issue #114


load data_opt_projtest_qp2lcp46

% check projection on polytope and polyhedron
P = Polyhedron(A,b);
P1 = P.projection([2,3]);

Q = polytope(A,b);
P2 = Q.projection([2,3]);
P3 = toPolyhedron(P2);

if P1~=P3
    error('Two projected polyhedra should be the same.');
end



end