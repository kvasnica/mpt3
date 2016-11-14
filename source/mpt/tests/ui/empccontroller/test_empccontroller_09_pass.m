function test_empccontroller_09_pass
%
% unbounded partition - some solvers did not return full partition 

%clear
close all

tic
%% test system
A = [0.7326 -0.0861; 0.1722 0.9909];
B = [0.0609; 0.0064];
C = [0 1.4142];
D = 0;
Ts = 0.1;

model = LTISystem('A',A,'B',B,'C',C,'D',D,'Ts',Ts);
model.u.min = -2;
model.u.max = 2;
model.x.penalty = InfNormFunction(eye(2));
model.u.penalty = InfNormFunction(0.01);

N = 6;
mpc = MPCController(model, N);
expmpc = mpc.toExplicit();
expmpc.partition.plot();
axis([-1 1 -1 1]);

if expmpc.partition.Num~=58
    error('The number of regions does not hold');
end
close all


end
