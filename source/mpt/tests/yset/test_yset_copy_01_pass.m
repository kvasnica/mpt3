function test_yset_copy_01_pass

% inequalities
x = sdpvar(1, 1);
con = [-1 <= x <= 1];
Y = YSet(x, con);
Q = Y.copy();
% assigning a variable in the original must leave the copy intact
assign(Y.vars, 3.4);
assert(isnan(double(Q.vars)));
% assigning a variable in the copy must leave the original intact
assign(Q.vars, 5.6);
assert(double(Y.vars)==3.4);
% check number of constraints
assert(length(sdpvar(Y.constraints))==2);
% do not compare length(Y.constraints) to length(Q.constraints) directly!
% the latter has double-sided constraints converted
assert(length(sdpvar(Y.constraints))==length(sdpvar(Q.constraints)));

% equalities
x = sdpvar(1, 1);
con = [-1 <= x <= 1] + [ x == 0 ];
Y = YSet(x, con);
Q = Y.copy();
% assigning a variable in the original must leave the copy intact
assign(Y.vars, 3.4);
assert(isnan(double(Q.vars)));
% assigning a variable in the copy must leave the original intact
assign(Q.vars, 5.6);
assert(double(Y.vars)==3.4);
% check number of constraints
assert(length(sdpvar(Y.constraints))==3);
% do not compare length(Y.constraints) to length(Q.constraints) directly!
% the latter has double-sided constraints converted
assert(length(sdpvar(Y.constraints))==length(sdpvar(Q.constraints)));

% nonlinear terms
x = sdpvar(2, 1);
con = [-1 <= x <= 1] + [ x'*x <= 2 ] + [ norm(x(2)) <= x(1)^2 ];
Y = YSet(x, con);
Q = Y.copy();
% assigning a variable in the original must leave the copy intact
assign(Y.vars, [3.4; 5.6]);
assert(all(isnan(double(Q.vars))));
% assigning a variable in the copy must leave the original intact
assign(Q.vars, [7.8; 8.9]);
assert(isequal(double(Y.vars), [3.4; 5.6]));
% check number of constraints
assert(length(sdpvar(Y.constraints))==6);
% do not compare length(Y.constraints) to length(Q.constraints) directly!
% the latter has double-sided constraints converted
assert(length(sdpvar(Y.constraints))==length(sdpvar(Q.constraints)));

% 3D
x = sdpvar(3, 1);
con = [ sin(x(2)) == 3 ] + [ -1 <= x <= 1 ] + [ x'*x <= 2 ];
Y = YSet(x, con);
Q = Y.copy();

end
