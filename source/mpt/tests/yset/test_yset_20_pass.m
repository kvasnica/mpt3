function test_yset_20_pass
%
% dimensions do not match
%

x = sdpvar(5,1);
y = sdpvar(2,1);

F = (-1<=y<=1);
G = ( randn(5)*x<=ones(5,1) );


% ok
YSet([x;y],[F;G]);

% false
[worked, msg] = run_in_caller('Y = YSet(y,G); ');
assert(~worked);
asserterrmsg(msg,'Dimension mismatch between the provided variables and the variables in the constraint set.');

end
