function test_yset_contains_07_pass
%
% lifting
%

x = sdpvar(2,1);
F = [-5 <= x(1) <= 5,x(2) == -(x(1)-2).^2];

Y = YSet(x,F);

if ~Y.contains([0;-4])
    error('This point must be contained in the set.');
end

if Y.contains([0;0])
    error('This point is outside.');
end


end