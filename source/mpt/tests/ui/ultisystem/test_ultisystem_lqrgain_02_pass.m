function test_ultisystem_lqrgain_02_pass
% tests ULTISystem/LQRGain with valid inputs

% no parametric uncertainty
A = 1; B = 1;
sys = ULTISystem('A', A, 'B', B);
sys.x.penalty = QuadFunction(10);
sys.u.penalty = QuadFunction(1.5);
[K, P] = sys.LQRGain();
Kexp = -0.883035394883899;
Pexp = 11.3245553180111;
assert(norm(K-Kexp)<1e-4);
assert(norm(P-Pexp)<1e-4);
assert(max(abs(eig(A+B*K)))<1); % check stability

% different weights
A = 1; B = 1;
sys = ULTISystem('A', A, 'B', B);
sys.x.penalty = QuadFunction(1);
sys.u.penalty = QuadFunction(1);
[K, P] = sys.LQRGain();
Kexp = -0.618031461495362;
Pexp = 1.61803398806263;
assert(norm(K-Kexp)<1e-4);
assert(norm(P-Pexp)<1e-4);
assert(max(abs(eig(A+B*K)))<1); % check stability

% same result for disturbances, which should be ignored
sys = ULTISystem('A', 1, 'B', 1);
sys.x.penalty = QuadFunction(1);
sys.u.penalty = QuadFunction(1);
sys.d.min = -1;
sys.d.max = 1;
[K, P] = sys.LQRGain();
Kexp = -0.618031461495362;
Pexp = 1.61803398806263;
assert(norm(K-Kexp)<1e-4);
assert(norm(P-Pexp)<1e-4);

% parametric uncertainty
A = {1, 2};
B = {3, 4, 5};
sys = ULTISystem('A', A, 'B', B);
sys.x.penalty = QuadFunction(1);
sys.u.penalty = QuadFunction(1);
[K, P] = sys.LQRGain();
Kexp = -0.374999999998982;
Pexp = 4.86666665350617;
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
