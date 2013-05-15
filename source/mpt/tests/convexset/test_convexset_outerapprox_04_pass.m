function test_convexset_outerapprox_04_pass
%
% V-polyhedron
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

P = Polyhedron('V',[1 -1; 2, 3; -5, 4; 0, 1]);

B = P.outerApprox;

if norm(B.Internal.lb-[-5;-1],1)>MPTOPTIONS.abs_tol
    error('Wrong lower bounds.');
end

if norm(B.Internal.ub-[2;4],1)>MPTOPTIONS.abs_tol
    error('Wrong upper bounds.');
end

end