function test_convexset_outerapprox_03_pass
%
% unbounded polyhedron
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

x = sdpvar(15,1);
F = set( randn(8,15)*x <= rand(8,1));

Y = YSet(x,F);

B = Y.outerApprox;

if B.isBounded
    error('Polyhedron must be unbounded.');
end
if any(~isinf(B.Internal.lb)) || any(~isinf(B.Internal.ub))
    error('Lower and upper bounds are Inf.');
end

end
