function test_convexset_outerapprox_01_pass
%
% empty set
%

x =sdpvar(2,1);
F = set( x <= 1) + set(x >= 2);

Y = YSet(x,F);

B = Y.outerApprox;

if ~B.isEmptySet
    error('Output should be empty.');
end

end
