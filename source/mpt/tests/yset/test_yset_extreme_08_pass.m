function test_yset_extreme_08_pass
%
% wrong orientation of argument (row/column vector)
%

x = sdpvar(1,2);

F = set(randn(5,2)*x'<= [1;2;3;4;5]);

S = YSet(x,F);

% z must be row, but is not
z = [ 1; 2];
s = S.extreme(z);


end
