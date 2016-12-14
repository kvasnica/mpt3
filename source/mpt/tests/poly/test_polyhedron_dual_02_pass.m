function test_polyhedron_dual_02_pass
% tests Polyhedron/dual for some bounded, full-dimensional stuff

% unit box in H-rep
A = [-1 0; 0 -1; 1 0; 0 1]; b = ones(4, 1);
P = Polyhedron(A, b);
D = P.dual();
Vexp = [-1 0;0 -1;0 0;0 1;1 0];
assert(D.hasVRep);
assert(norm(sortrows(D.V)-Vexp)<1e-6);
% for bounded polyhedra we have that the dual of a dual is the original
Dd = D.dual();
assert(Dd==P);

%% rectangle in H-rep with the origin in the strict interior
A = [-1 0; 0 -1; 1 0; 0 1]; b = [1; 1; 2; 3];
P = Polyhedron(A, b);
D = P.dual();
Vexp = [-1 0;0 -1;0 0;0 1/3;0.5 0];
assert(D.hasVRep);
assert(norm(sortrows(D.V)-Vexp)<1e-6);
% for bounded polyhedra we have that the dual of a dual is the original
Dd = D.dual();
assert(Dd==P);

%% unit box in V-rep with the origin in the strict interior
V = [1 1; 1 -1; -1 1; -1 -1];
P = Polyhedron(V);
D = P.dual();
assert(D.hasHRep);
assert(isequal(D.A, V));
assert(isequal(D.b, ones(4, 1)));
% for bounded polyhedra we have that the dual of a dual is the original
Dd = D.dual();
assert(Dd==P);

%% rectangle in V-rep with the origin in the strict interior
V = [-1 3;2 3;2 -1;-1 -1];
P = Polyhedron(V);
D = P.dual();
assert(D.hasHRep);
assert(isequal(D.A, V));
assert(isequal(D.b, ones(4, 1)));
% for bounded polyhedra we have that the dual of a dual is the original
Dd = D.dual();
assert(Dd==P);

%% box with the origin as one of its vertices
PV = Polyhedron([0 0; 0 1; 1 0; 1 1]);
PH = Polyhedron('H', [0 -1 0;0.70711 -4.7443e-17 0.70711;8.7561e-17 0.70711 0.70711;-1 3.3307e-16 1.1102e-16]);
DV = PV.dual();
DH = PH.dual();
QV = DV.dual();
QH = DH.dual();
assert(QV==PV);
assert(QH==PH);

%% trapezoid with the origin as one of its vertices
PV = Polyhedron([0 0; 0 2; 3 0; 3 1]);
PH = Polyhedron('H', [0 -1 0;0.316227766016838 -8.1453146730132e-17 0.948683298050514;0.147441956154897 0.442325868464691 0.884651736929383;-1 1.11022302462516e-16 1.11022302462516e-16]);
DV = PV.dual();
DH = PH.dual();
QV = DV.dual();
QH = DH.dual();
assert(QV==PV);
assert(QH==PH);

%% lower dimensional polyhedron with the origin in its strict interior
% V-rep
PV = Polyhedron([-1 0; 2 0]);
DV = PV.dual();
ZV = DV.dual();
assert(~PV.isFullDim());
assert(DV.isFullDim());
Hexp = [-1 0 1;2 0 1];
assert(isequal(sortrows(DV.H), Hexp));
assert(ZV==PV);
% H-rep
PH = Polyhedron('H', [1 0 2;-1 0 1], 'He', [0 -1 0]);
DH = PH.dual();
ZH = DH.dual();
assert(~PH.isFullDim());
assert(DH.isFullDim());
assert(ZH==PH);
assert(DH==DV); % the two duals must be equal

%% lower dimensional polyhedron with the origin at the boundary
% V-rep
PV = Polyhedron([0 0; 2 0]);
DV = PV.dual();
ZV = DV.dual();
assert(~PV.isFullDim());
assert(DV.isFullDim());
Hexp = [0 0 1;2 0 1];
assert(isequal(sortrows(DV.H), Hexp));
assert(ZV==PV);
% H-rep
PH = Polyhedron('H', [1 0 2;-1 0 0], 'He', [0 -1 0]);
DH = PH.dual();
ZH = DH.dual();
assert(~PH.isFullDim());
assert(DH.isFullDim());
assert(ZH==PH);
assert(DH==DV); % the two duals must be equal

% %% lower dimensional V-polyhedron which does not contain the origin
% P = Polyhedron([0 1; 2 0.5]);
% D = P.dual();
% Z = D.dual();
% assert(~P.isFullDim());
% assert(D.isFullDim());
% assert(Z==P);
% 
% %% polytope which does not contain the origin
% P = Polyhedron('H', [-1 0 -1;0 -1 -1;1 0 2;0 1 2]);
% D = P.dual();
% Vexp = [-0.5 1.5;1.5 -0.5;1.5 1.5;1.5 3.5;3.5 1.5];
% assert(norm(sortrows(D.V) - Vexp, Inf) < 1e-6);
% 
% %% the same but the input is in the V-representation
% P = Polyhedron([2 1;1 1;1 2;2 2]);
% D = P.dual();
% Vexp = [-0.5 1.5;1.5 -0.5;3.5 1.5;1.5 3.5];
% assert(norm(sortrows(D.V) - sortrows(Vexp), Inf) < 1e-6);
% 
% %% another box that doesn't have the origin in its interior
% P = Polyhedron.unitBox(2)+[5; 0];
% D = P.dual();
% assert(isempty(D.R));
% Vexp = [4 0;5 -1;5 0;5 1;6 0];
% assert(norm(sortrows(D.V)-Vexp)<1e-6);
% Q = D.dual();
% Hexp = [-1 0 -4;0 -1 1;0 0 1;0 1 1;1 0 6];
% assert(isempty(Q.He));
% assert(norm(sortrows(Q.H)-Hexp)<1e-6);
% assert(P==Q);

end
