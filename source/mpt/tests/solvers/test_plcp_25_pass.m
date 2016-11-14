function test_plcp_25_pass
% I am getting the message "Couldn't compute point on a facet" when
% computing an explicit controller. I am running the latest development
% version of mpt. Before I started running the latest development version,
% I got the message "Feasible set is wrong, please report to
% m...@control.ee.ethz.ch" described in this topic:
% https://groups.google.com/forum/#!topic/mpt-user/QU4D7umvf-Q      
%
%
% In addition to the message "Couldn't compute point on a facet", mpt
% generates 815 regions when running the code below, which seems like a lot
% for a 4-dimensional LTI system. Does this have anything to do with the
% "Couldn't compute point on a facet" that I'm getting?   
%
% Thanks!
% Stephanie



% Continuous time system matrices
A = [0 1 0 0;
       0 0 9.81 0;
       0 0 0 1;
       0 0 0 -1];
B = [0 0 0 1]';

% MH: provided missing data
C = eye(4);
D = zeros(4,1);
timestep = 0.2; %0.1
horizon = 4; %5

% Penalty matrices
Q = diag([1 .1 .5 .1]);
R = 1;

% Convert the continuous system into a discrete system, create MPT model
discrete_system = c2d(ss(A,B,C,D), timestep);
Ad = discrete_system.a;
Bd = discrete_system.b;
model = LTISystem('A', Ad, 'B', Bd);

% Set bounds and penalties on the new system
deg2rad = pi/180;
model.x.min = [-10; -10; -10*deg2rad; -10*deg2rad];
model.x.max = [10; 10; 10*deg2rad; 10*deg2rad];
model.u.min = -15*deg2rad;
model.u.max = 15*deg2rad;
model.x.penalty = QuadFunction(Q);
model.u.penalty = QuadFunction(R);

% Get the controller
mpc = MPCController(model, horizon);
explicit_controller = mpc.toExplicit();

% load solution
load data_test_plcp25

if explicit_controller.optimizer.convexHull~=hull
    error('The convex hull does not hold.');
end

end