function test_yset_21_pass
%
% 3D matrices not allowed
%

x = sdpvar(5,2,3);

F = set(x<=1);

% false
[worked, msg] = run_in_caller('Y = YSet(x,F); ');
assert(~worked);
asserterrmsg(msg,'Variables must be provided as vectors only.');

end
