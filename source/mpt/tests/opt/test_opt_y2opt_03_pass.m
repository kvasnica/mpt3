function test_opt_y2opt_03_pass
% Yalmip fesibility problem



A = randn(10,2);
b = 10*rand(10,1);
E = randn(10,2);
f = 0.1*rand(10,1);
w = sdpvar(2,1);
x = sdpvar(2,1);

F = [A*(x+w) <= b, E*w <= f];

% solve using mpt2
SOL = solvemp(F,0,sdpsettings('verbose',0),x,w);

if isempty(SOL)
    error('The result should be feasible.');
end

% solve using mpt3
prb = Opt(F,0,x,w);
r = prb.solve;

Pn1 = Polyhedron('h',double(hull(SOL{1}.Pn)));
Pn2 = r.xopt.convexHull;

if ~Pn1.contains(Pn2) && ~Pn2.contains(Pn1)
    error('Polyhedra should be the same.');
end

end
