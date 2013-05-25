function test_ltisystem_LQRGain_01_pass
% tests LTISystem/LQRGain()

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = 0*randn(ny, nu); 
f = randn(nx, 1); g = randn(ny, 1);
Q = eye(nx); R = 10*eye(nu);

L = LTISystem('A', A, 'B', B, 'C', C, 'D', D);
% L.x.with('penalty');
L.x.penalty = QuadFunction(Q);
% L.u.with('penalty');
L.u.penalty = QuadFunction(R);

K = L.LQRGain();
Kgood = dlqr(A, B, Q, R);

assert(isequal(K, -Kgood));

end
