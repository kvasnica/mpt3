function test_ltisystem_10_pass
% wrong dimensions

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nu, nu); 
C = randn(ny, nx); D = randn(ny, nu); Ts = rand;

[worked, msg] = run_in_caller('L = LTISystem(''A'', A, ''B'', B, ''C'', C); ');
assert(~worked);
asserterrmsg(msg,'The "B" matrix must have 3 rows.');

end

