function test_ultisystem_mpc_02_pass
% MPC synthesis based on ULTISystems with parametric uncertainties

%% 1D system with parametric uncertainty in A
sys = ULTISystem('A', {0.8, 1.2}, 'B', 1);
sys.x.min = -2;
sys.x.max = 2;
sys.u.min = -1;
sys.u.max = 1;
sys.x.penalty = QuadFunction(1);
sys.u.penalty = QuadFunction(1);
N = 3;
ctrl = MPCController(sys, N);
ectrl = ctrl.toExplicit();
assert(ectrl.optimizer.Num==3);
assert(isequal(sortrows(ectrl.optimizer.Domain.V), [-2; 2]));
x=2.1; assert(isnan(ctrl.evaluate(x))); % outside of feasible set
x=2; uexp = -1; assert(norm(ctrl.evaluate(x)-uexp)<1e-6);
x=0.5; uexp = -0.3; assert(norm(ctrl.evaluate(x)-uexp)<1e-6);

%% same but with terminal set
sys.x.with('terminalSet');
sys.x.terminalSet = Polyhedron('lb', -0.4, 'ub', 0.4);
ctrl = MPCController(sys, N);
ectrl = ctrl.toExplicit();
assert(ectrl.optimizer.Num==5);
x=1+1/3+1e-2; u=ctrl.evaluate(x); assert(isnan(u) || u==0); % outside of feasible set
x=1+1/3; uexp = -1; assert(norm(ctrl.evaluate(x)-uexp)<1e-6);
x=0.5; uexp = -0.3; assert(norm(ctrl.evaluate(x)-uexp)<1e-6);

%% double integrator with parametric uncertainty in A
sys = ULTISystem('A', { [1 1; 0 0.9], [1 1; 0 1.1] }, 'B', [1; 0.5]);
sys.x.min = [-5; -5];
sys.x.max = [5; 5];
sys.x.penalty = QuadFunction(eye(2));
sys.u.min = -1;
sys.u.max = 1;
sys.u.penalty = QuadFunction(1);
% simple MPC without any terminal constraints
N = 3;
ctrl = MPCController(sys, N);
x0 = [5; 0];
[u, feasible, ol] = ctrl.evaluate(x0);
uexp = -1;
assert(norm(u-uexp)<1e-6);
assert(feasible);
Jexp = 50.5;
assert(norm(ol.cost-Jexp)<1e-6);
% explicit MPC should also work
ectrl = ctrl.toExplicit();
assert(ectrl.optimizer.Num==9);
% expected domain:
E = Polyhedron('H', [-1 0 5;1 0 5;-0.707106781186547 -0.707106781186547 4.24264068711928;-0.429933580392348 -0.90286051882393 3.22450185294261;-0.316227766016838 -0.948683298050514 3.00416377715996;0.707106781186548 0.707106781186548 4.24264068711928;0.316227766016838 0.948683298050514 3.00416377715996;0.429933580392348 0.90286051882393 3.22450185294261]);
assert(ectrl.optimizer.Domain==E);

%% same but with terminal set
sys.x.with('terminalSet');
sys.x.terminalSet = Polyhedron('lb', 0.1*[-1; -1], 'ub', 0.1*[1; 1]);
ctrl = MPCController(sys, N);
ectrl = ctrl.toExplicit();
% assert(ectrl.optimizer.Num==39);
% expected domain:
%E = Polyhedron('H', [0 -1 0.476190476190537;-0.946772744819712 -0.321902733238704 1.07587811911331;-0.662059462410689 -0.749451311448895 0.993089193616024;0.405837203999312 -0.913945383406482 0.446420924399224;0.426618675712988 -0.904431592511505 0.443424865968344;0 1 0.476190476190451;0.73593101176183 -0.677056530820883 0.76269213946226;-0.992876838486922 -0.119145220618431 1.02898145079554;0.992876838486922 0.119145220618431 1.02898145079554;0.66205946241069 0.749451311448895 0.99308919361603;0.946772744819712 0.321902733238705 1.07587811911331;-0.735931011761828 0.677056530820885 0.762692139462258;-0.426618675712979 0.904431592511509 0.443424865968339;-0.405837203999311 0.913945383406482 0.446420924399105]);
E = Polyhedron('H', [0 -1 0.476190476190476;-0.946772744819712 -0.321902733238703 1.07587811911331;-0.662059462410689 -0.749451311448895 0.99308919361603;-0.992876838486922 -0.119145220618432 1.02898145079554;-0.735931011761832 0.67705653082088 0.762692139462263;-0.426618675712963 0.904431592511517 0.443424865968341;0 1 0.476190476190358;0.735931011761827 -0.677056530820886 0.762692139462257;0.42661867571298 -0.904431592511509 0.443424865968336;0.992876838486922 0.119145220618432 1.02898145079554;0.662059462410689 0.749451311448895 0.993089193616025;0.946772744819712 0.321902733238703 1.07587811911331]);
assert(ectrl.optimizer.Domain==E);

end
