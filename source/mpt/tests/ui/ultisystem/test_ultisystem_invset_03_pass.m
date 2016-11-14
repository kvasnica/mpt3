function test_ultisystem_invset_03_pass
% ULTISystem/invariantSet() with parametric uncertainties

%% autonomous system with parametric uncertainties
A = {[0.5 0; 1 -0.5], [0.9 0; 1 -0.5] };
sys = ULTISystem('A', A);
sys.x.min = [-10; -10];
sys.x.max = [10; 10];
[Z, conv, iters] = sys.invariantSet();
E = Polyhedron('H', [1 -0.5 10;-1 0.5 10;1 0 10;0 1 10;-1 0 10;0 -1 10]);
assert(Z==E);
assert(conv);
assert(iters==2);

%% system with inputs and parametric uncertainties
A = {[0.5 1; 1 -0.5], [1.5 0; 1 -0.5] };
B = [1; 0.1];
sys = ULTISystem('A', A, 'B', B);
sys.x.min = [-10; -10];
sys.x.max = [10; 10];
sys.u.min = -5;
sys.u.max = 5;
[Z, c, iters] = sys.invariantSet();
E = Polyhedron('H', [0.94528533069949 -0.597022314125993 10.4186254141167;1 -0.5 10.5;-0.94528533069949 0.597022314125993 10.4186254141167;-1 0.5 10.5;1 0 10;0 1 10;-1 0 10;0 -1 10]);
assert(Z==E);
assert(conv);
assert(iters==7);

end