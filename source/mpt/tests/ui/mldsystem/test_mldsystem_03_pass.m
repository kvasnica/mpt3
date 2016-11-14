function test_mldsystem_03_pass
% tests proper indexing of binary variables (52183b92f49e)

param1 = 0.5;
param2 = 3.7;
period = 6;
param3 = [0.5;1.5;2.5]*param2;
epsilon = 0.1;

%% Initial State
initialState=[  
    15; param3(2);    10; param3(2);... 
    30; 10;...                      
    1; 0; 0; 0; 0;...               
    ];
            
%% Hybrid System
parameters.param1 = param1;
parameters.param2 = param2;
parameters.param3 = param2/period;
parameters.epsilon = epsilon;
model = MLDSystem('data_mldsystem_binary_01.hys', parameters);

%% MPC problem formulation
ctrl = MPCController(model);

%Prediciton horizon
ctrl.N=4;

%Fixed reference tracking
ctrl.model.x.without('penalty');
ctrl.model.u.without('penalty');
Q=zeros(size(ctrl.model.C,1));
Q(2,2)=1;
Q(3,3)=1;
ctrl.model.y.penalty = OneNormFunction(Q);

ctrl.model.y.with('reference');
yReference = zeros(size(ctrl.model.C,1),1);
yReference(2:3) = [param3(2);10];
ctrl.model.y.reference = yReference;

%% Open-loop
[Uonl, feasible, openloop] = ctrl.evaluate(initialState);
assert(feasible);
Jexp = 0;
assert(abs(openloop.cost - 0) < 1e-8);
Xexp = [15 20 25 30 34.5;5.55 5.55000000000001 5.55000000000005 5.55 5.24166666666664;10 10 10 10 8;5.55 5.55 5.54999999999999 5.54999999999999 1.84999999999995;30 30 30 30 30;10 0 0 0 0;1 1 1 0 0;0 0 0 0 0;0 0 0 0 1;0 0 0 0 0;0 0 0 1 0];
assert(norm(openloop.X - Xexp, Inf) < 1e-5);

end