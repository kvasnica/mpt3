function test_opt_y2opt_04_pass
% Yalmip lp problem

global MPTOPTIONS

A = randn(10,2);
b = 10*rand(10,1);
B = randn(10,2);
E = randn(10,2);
f = 5*rand(10,1);
w = sdpvar(2,1);
x = sdpvar(2,1);

F = set([A*x <= b + B*w, E*w <= f]);

% solve using mpt2
SOL = solvemp(F,x(1)-x(2),sdpsettings('verbose',0),w,x);

if isempty(SOL)
    error('The result should be feasible.');
end

% solve using mpt3
prb = Opt(F,x(1)-x(2),w,x);
r = prb.solve;

Pn1 = Polyhedron('h',double(hull(SOL{1}.Pn)));
Pn2 = r.xopt.convexHull;

[isin,inwhich1]=isInside(r.xopt.Set,[0;0]);
[isin,inwhich2]=isinside(SOL{1}.Pn,[0;0]);

if norm(r.xopt.Set(inwhich1).Functions('primal').F-SOL{1}.Fi{inwhich2})>MPTOPTIONS.rel_tol
    error('Wrong computation of control law.');
end

if ~Pn1.contains(Pn2) && ~Pn2.contains(Pn1)
    error('Polyhedra should be the same.');
end

end
