function test_convexset_outerapprox_08_pass
%
% unbounded polyhedron in 5D (positive orthant)
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

lb = zeros(1,5);
P = Polyhedron('lb',lb);

B = P.outerApprox;

   
if norm(B.Internal.lb-lb')>MPTOPTIONS.abs_tol
    error('Wrong lower bounds.');
end


end