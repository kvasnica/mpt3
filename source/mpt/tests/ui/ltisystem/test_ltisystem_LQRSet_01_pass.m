function test_ltisystem_LQRSet_01_pass
% tests LTISystem/LQRSet()

Double_Integrator
sysStruct.xmax = sysStruct.ymax;
sysStruct.xmin = sysStruct.ymin;

L = LTISystem(sysStruct);
% L.x.with('penalty');
L.x.penalty = Penalty(probStruct.Q, 2);
% L.u.with('penalty');
L.u.penalty = Penalty(probStruct.R, 2);

S = L.LQRSet();

Agood = [0.135017323795083 -0.280916176928742;-0.135017323795083 0.280916176928742;-0.00533643109831478 -0.529404762529574;0.00533643109831478 0.529404762529574;-0.519754007452359 -0.939957536022068;0.519754007452359 0.939957536022068];
bgood = [1;1;1;1;1;1];
Sgood = Polyhedron('A', Agood, 'b', bgood);

assert(S==Sgood);

end
