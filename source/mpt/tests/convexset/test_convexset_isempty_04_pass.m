function test_convexset_isempty_04_pass
%
% array of empty sets
%

x = sdpvar(3,1);
F1 = set(x'*x + x <= -1);
F2 = set( 0.2*x'*x + 0.5*x <= -2);
F3 = set( abs(x) <= -1);
Y1 = YSet(x,F1);
Y2 = YSet(x,F2);
Y3 = YSet(x,F3);

Y = [Y1, Y2, Y3];

if any(~Y.isEmptySet)
    error('This set is empty.');
end

end
