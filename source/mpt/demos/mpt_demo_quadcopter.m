function mpt_demo_quadcopter
%
% Formulation of MPC problem for unmanned aerial vehicle or quadcopter
%

close all

% load state-space model in the Control Toolbox format, as provided by
% Carlo Alberto Pascucci <ca.pascucci@imtlucca.it> 

load quadcopter_ssmodel

% the model is linearized around the following steady state
u0 = [10.5916; 10.5916;  10.5916; 10.5916];
x0 = zeros(12,1);


%% create model in MPT3 
% convert the state-space representation from Matlab Control Toolbox
model = LTISystem(sysd);


%% formulate MPC problem 
ctrl = MPCController(model);

% set the prediction horizon
ctrl.N = 10;

% the control horizon is equal to the prediction horizon, if we require
% control horizon 2, then we have to add block constraints for remaining
% steps
% add a move-blocking constraint
ctrl.model.u.with('block');
ctrl.model.u.block.from = 3;
ctrl.model.u.block.to = ctrl.N;

% input constraints (no slew rate constraints)
ctrl.model.u.min = [9.6; 9.6; 9.6; 9.6]-u0;
ctrl.model.u.max = [13; 13; 13; 13]-u0;

% output constraints
ctrl.model.y.min = [-pi/6; -pi/6; -Inf; -Inf; -Inf; -1; -Inf(6,1)];
ctrl.model.y.max = [pi/6; pi/6; Inf; Inf; Inf; Inf; Inf(6,1)];

% add reference signals
ctrl.model.y.with('reference');
ctrl.model.y.reference = [0;0;1;0;0;0;zeros(6,1)];

% active slew rate constraints
ctrl.model.u.with('deltaPenalty');
% add quadratic penalty on the input rates
ctrl.model.u.deltaPenalty = QuadFunction(0.1*eye(4));

% add quadratic penalty on the outputs
ctrl.model.y.penalty = QuadFunction(diag([0 0 10 10 10 10 0 0 0 5 5 5]));


%% Simulate the closed loop
N_sim = 30;

% Create the closed-loop system:
loop = ClosedLoop(ctrl, model);

% provide initial conditions including the values for inputs because the
% delta penalty is activated
data = loop.simulate(x0, N_sim, 'u.previous', zeros(4,1));

% plot the output trajectories
figure
plot(0:N_sim-1,data.Y,'LineWidth',2)
xlabel('Simulation steps')
title('Outputs')

% to plot output we add the steady state value u0
Up = data.U + repmat(u0,1,N_sim);
figure
plot(0:N_sim-1,Up,'LineWidth',2)
xlabel('Simulation steps')
title('Control inputs')

end
