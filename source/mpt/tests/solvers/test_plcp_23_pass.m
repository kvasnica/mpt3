function test_plcp_23_pass
% test from MPC course that showed holes in the solution

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
model.x.penalty = Penalty(eye(2), Inf);
model.u.penalty = Penalty(0.01, Inf);

N = 6;
mpc = MPCController(model, N);
expmpc = mpc.toExplicit();


Pfinal = expmpc.partition.Internal.convexHull;

x = grid(Pfinal,30);

for i=1:size(x,1)
    if ~isInside(expmpc.partition.Set,x(i,:)')
        error('There is a hole in the solution');
    end
end

end