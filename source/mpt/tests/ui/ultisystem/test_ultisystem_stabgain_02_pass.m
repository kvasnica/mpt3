function test_ultisystem_stabgain_02_pass
% tests ULTISystem/stabilizingGain with valid inputs

% no parametric uncertainty
A = 1; B = 1;
sys = ULTISystem('A', A, 'B', B);
[K, P] = sys.stabilizingGain();
Kexp = -1;
Pexp = 1e-4;
assert(norm(K-Kexp)<1e-6);
assert(norm(P-Pexp)<1e-6);
assert(max(abs(eig(A+B*K)))<1); % check stability

% same result with state/input penalties
A = 1; B = 1;
sys = ULTISystem('A', A, 'B', B);
sys.x.penalty = QuadFunction(10);
sys.u.penalty = QuadFunction(1.5);
[K, P] = sys.stabilizingGain();
Kexp = -1;
Pexp = 1e-4;
assert(norm(K-Kexp)<1e-6);
assert(norm(P-Pexp)<1e-6);
assert(max(abs(eig(A+B*K)))<1); % check stability

% parametric uncertainty
A = {1, 2};
B = {3, 4, 5};
sys = ULTISystem('A', A, 'B', B);
[K, P] = sys.stabilizingGain();
Kexp = -0.366592797156274;
Pexp = 1e-4;
assert(norm(K-Kexp)<1e-4);
assert(norm(P-Pexp)<1e-4);
% check that all combinations give a stable system
for ia = 1:numel(A)
    for ib = 1:numel(B)
        Acl = A{ia}+B{ib}*K;
        assert(max(abs(eig(Acl)))<1);
    end
end

end
