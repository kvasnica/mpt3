function test_convexset_outerapprox_07_pass
%
% only equalities, lb and ub are given
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

lb = [2,3];
ub = [4,5];
P = Polyhedron('He',[1 -0.5 0.6],'lb',lb,'ub',ub);

B = P.outerApprox;

   
if norm(B.Internal.lb-[2.1;3])>MPTOPTIONS.abs_tol
    error('Wrong lower bounds.');
end

if norm(B.Internal.ub-[3.1;5])>MPTOPTIONS.abs_tol
    error('Wrong upper bounds.');
end

end