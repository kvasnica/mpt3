function test_ultisystem_reachset_05_pass
% preset with parametric uncertainty was wrong
% reported by jingyilu2010@gmail.com on June 17, 2016


A1 = [0.4,      -0.5916,    0;
      1,        0,          0;
      -2.095,   1,          1];
A2 = [1,    1,  0;
      1,    1,  0;
      -3.109,-3.109,1;];
As1 = {A1, A2};
B = [1;   0;  -1.69];
sys1 = ULTISystem('A', As1, 'B', B);
Ax = [1.0483,   0,  0;
      -1.0483,  0,  0;
      2.095,    -1,  0;
      -2.095,   1,   0;
      3.109,    3.109, 0;
      -3.109,   -3.109, 0;
      0,        0,      1;
      0,        0,      -1;];
Bx = [6; 6; 16.407; 16.407; 16.407;16.407;4.435;4.435;];
Xp = Polyhedron('A', Ax, 'B', Bx);  % the target set
Hu = [1; -1];
hu = [10; 10];
Up = Polyhedron(Hu, hu);

preSet = sys1.reachableSet('direction', 'backward', 'X', Xp, 'U', Up);


%% x0 must not be in the preset
x0 = [-0.5509; 2.9019; 4.2824];
assert(~preSet.contains(x0));
% test via yalmip:
sdpvar u
info = solvesdp([Xp.A*(A1*x0+B*u)<=Xp.b; Xp.A*(A2*x0+B*u)<=Xp.b; Hu*u<=hu]);
assert(info.problem==1); % must be infeasible

%% this x0 must be contained in the rpeset
x0 = [-0.198885751308012;0.0490801050928024;3.6007667555898];
assert(preSet.contains(x0));
% test via yalmip:
sdpvar u
opt = sdpsettings('verbose', 0);
info = solvesdp([Xp.A*(A1*x0+B*u)<=Xp.b; Xp.A*(A2*x0+B*u)<=Xp.b; Hu*u<=hu], [], opt);
assert(info.problem==0); % must be infeasible

end
