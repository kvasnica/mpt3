function test_convexset_outerapprox_06_pass
%
% only equalities
%


P = Polyhedron('He',[1 -0.5 0.6]);

B = P.outerApprox;

lb = -1e4*ones(2,1);
ub = 1e4*ones(2,1);
   
if any(B.Internal.lb>lb)
    error('Wrong lower bounds.');
end

if any(B.Internal.ub<ub)
    error('Wrong upper bounds.');
end

end