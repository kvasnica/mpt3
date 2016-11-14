function test_ltisystem_toSS_03_pass
% LTISystem/toSS should fail if no sampling time is specified

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); Ts = rand;

[worked,msg] = run_in_caller('L = LTISystem(''A'', A, ''B'', B, ''C'', C, ''D'', D, ''Ts'', []);');
assert(~worked);
%S = L.toSS();


end

