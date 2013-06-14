function test_convexset_outerapprox_01_pass
%
% empty set
%

x = sdpvar(2,1);
F = [ x <= 1; x >= 2 ];

Y = YSet(x,F);

B = Y.outerApprox;

if ~B.isEmptySet
    error('Output should be empty.');
end

end
