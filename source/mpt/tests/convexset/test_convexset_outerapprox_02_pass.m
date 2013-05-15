function test_convexset_outerapprox_02_pass
%
% circle
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

x = sdpvar(2,1);
F = set( x'*x <= 1);

Y = YSet(x,F);

B = Y.outerApprox;

if norm(B.Internal.lb+1,1)>MPTOPTIONS.abs_tol    
    error('Lower bound must be -1.');
end
if norm(B.Internal.ub-1,1)>MPTOPTIONS.abs_tol    
    error('Upper bound must be 1.');
end

end
