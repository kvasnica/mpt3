function test_yset_copy_02_pass
% copying of a single YSet with functions

x = sdpvar(1, 1); 
P = YSet(x, [-1 <= x <= 1]);
P.addFunction(@(x) x, 'g');
P.addFunction(@(x) x, 'other');
assert(P.hasFunction('g'));
assert(~P.hasFunction('f'));
Q = P.copy();
assert(Q.hasFunction('g'));
assert(~Q.hasFunction('f'));

% adding a function to Q must not affect P
Q.addFunction(@(x) x, 'f');
assert(Q.hasFunction('f'));
assert(~P.hasFunction('f'));

% adding a function to P must not affect Q
P.addFunction(@(x) x, 'h');
assert(P.hasFunction('h'));
assert(~Q.hasFunction('h'));

% removing a function from the original must leave the copy intact
P.removeFunction('g');
assert(~P.hasFunction('g'));
assert(Q.hasFunction('g'));

% removing a function from the copy must leave the original intact
Q.removeFunction('other');
assert(P.hasFunction('other'));
assert(~Q.hasFunction('other'));

end
