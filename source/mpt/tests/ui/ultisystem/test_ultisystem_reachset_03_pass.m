function test_ultisystem_reachset_03_pass
% ULTISystem/reachableSet with parametric uncertainties

%% no inputs, pre-set (backwards), example 11.10 from MM's book
A = {[0.5 0; 1 -0.5], [1 0; 1 -0.5]};
S = Polyhedron('lb', [-10; -10], 'ub', [10; 10]);
sys = ULTISystem('A', A);
sys.d.min = [-1; -1];
sys.d.max = [1; 1];
Z = sys.reachableSet('X', S, 'direction', 'backward');
E = Polyhedron('H', [-1 0.5 9;1 -0.5 9;-1 0 9;1 0 9]);
assert(Z==E);
% same but with custom D
W = Polyhedron.unitBox(2);
sys.d.min = [-10; -10];
sys.d.max = [10; 10];
Z = sys.reachableSet('X', S, 'direction', 'backward', 'D', W);
assert(Z==E);
% same but with only one disturbance
sys = ULTISystem('A', A, 'E', [1; 1]);
sys.d.min = -1;
sys.d.max = 1;
Z = sys.reachableSet('X', S, 'direction', 'backward');
assert(Z==E);
% same but with X constructed from bounds
sys.x.min = [-10; -10];
sys.x.max = [10; 10];
Z = sys.reachableSet('direction', 'backward');
assert(Z==E);

%% no inputs, reach-set (forward), example 11.11 from MM's book
A = {[0.5 0; 1 -0.5], [1 0; 1 -0.5]};
S = Polyhedron('lb', [-10; -10], 'ub', [10; 10]);
sys = ULTISystem('A', A);
Z = sys.reachableSet('X', S, 'direction', 'forward');
% two sets must be returned
assert(isa(Z, 'Polyhedron'));
assert(numel(Z)==2);
E1 = Polyhedron('H', [0 -1 15;0.894427190999916 -0.447213595499958 2.23606797749979;0 1 15;1 0 5;-0.894427190999916 0.447213595499958 2.23606797749979;-1 0 5]);
E2 = Polyhedron('H', [0 -1 15;0.707106781186547 -0.707106781186547 3.53553390593274;0 1 15;1 0 10;-0.707106781186547 0.707106781186547 3.53553390593274;-1 0 10]);
assert((Z(1)==E1 && Z(2)==E2) || (Z(1)==E2 && Z(2)==E1));
% direction=forward should be the default
Z = sys.reachableSet('X', S);
assert((Z(1)==E1 && Z(2)==E2) || (Z(1)==E2 && Z(2)==E1));
% specify a fine grid of the parametric uncertainty
Aunc = {[0.5 0; 1 -0.5], [0.6 0; 1 -0.5], [0.7 0; 1 -0.5], [0.8 0; 1 -0.5], [0.9 0; 1 -0.5], [1 0; 1 -0.5]};
Z = sys.reachableSet('X', S, 'A', Aunc);
assert(numel(Z)==numel(Aunc));

%% inputs, pre-set (backwards), example 11.9 from MM's book

%% inputs, reach-set (forward), example 11.9 from MM's book

end
