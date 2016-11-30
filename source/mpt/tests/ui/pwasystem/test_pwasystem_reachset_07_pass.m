function test_pwasystem_reachset_07_pass
% intermediate empty sets must be dealt with correctly
% reported by Wilson on Nov 17, 2016

T_s = 0.1;
As_x_1 = [-1,0;
    1,0;
    0,-1;
    0,1;];
Bs_u_1 = [0.4;0.4;1;1];
As_x_2 = [-1,0;
    1,0;
    0,-1;
    0,1;];
Bs_u_2 = [-0.4;1;1;1;];
As_x_3 = [-1,0;
    1,0;
    0,-1;
    0,1;];
Bs_u_3 = [1;-0.4;1;1];
Ps_1 = Polyhedron(As_x_1,Bs_u_1);
Ps_2 = Polyhedron(As_x_2,Bs_u_2);
Ps_3 = Polyhedron(As_x_3,Bs_u_3);
m = 1;
k1 = 1.25;
k2 = 2/0.6;
b2 = 0.4* (k1 - k2);
k3 = k2;
b3 = -b2;
dm = 1.1 * 1.5;
A_1 = [1,T_s;
    -k1*T_s/m,1-dm*T_s/m];
A_2 = [1,T_s;
    -k2*T_s/m,1-dm*T_s/m];
A_3 = [1,T_s;
    -k3*T_s/m,1-dm*T_s/m];
B = [0;T_s/m];
f_1 = [0;0];
f_2 = [0;-T_s*b2/m];
f_3 = [0;-T_s*b3/m];
model1 = LTISystem('A',A_1,'B',B,'f',f_1);
model2 = LTISystem('A',A_2,'B',B,'f',f_2);
model3 = LTISystem('A',A_3,'B',B,'f',f_3);
model1.setDomain('x', Ps_1);
model2.setDomain('x', Ps_2);
model3.setDomain('x', Ps_3);
pwa = PWASystem([model1, model2, model3]);%
pwa.x.min = [-1; -1;];
pwa.x.max = [1; 1;];
pwa.u.min = -0.6;
pwa.u.max = 0.6;
U = Polyhedron('lb',pwa.u.min,'ub',pwa.u.max);
S1 = Ps_2;
K_f = pwa.reachableSet('X', S1, 'U', U, 'direction', 'forward','N',1);
% backward computation used to fail and return a single empty set while the
% correct result has 2 non-empty sets
K_b = pwa.reachableSet('X', K_f, 'U', U, 'direction', 'backward','N',1);
assert(isa(K_f, 'Polyhedron'));
assert(numel(K_f)==3);
assert(all(~isEmptySet(K_f)));
assert(isa(K_b, 'Polyhedron'));
assert(numel(K_b)==2);
assert(all(~isEmptySet(K_b)));

end
