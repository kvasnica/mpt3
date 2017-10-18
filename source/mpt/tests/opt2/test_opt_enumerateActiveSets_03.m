function test_opt_enumerateActiveSets_03
% degenerate pQP
%
% Tondel, P., Johansen, T. A., & Bemporad, A. (2003, December). Further
% results on multiparametric quadratic programming. In Decision and
% Control, 2003. Proceedings. 42nd IEEE Conference on (Vol. 3, pp.
% 3173-3178). IEEE.   
% https://pdfs.semanticscholar.org/da11/941d892e52065b3b34f2f51322d35abd5343.pdf

H = eye(3);
A = [1 0 -1; -1 0 -1; 0 1 -1; 0 -1 -1];
b = -ones(4, 1);
pB = [1 0; -1 0; 0 -1; 0 1];
Ath = [eye(2); -eye(2)]; bth = 2*ones(4, 1);

solver = 'rlenumpqp';
pqp = Opt('H', H, 'A', A, 'b', b, 'pB', pB, 'Ath', Ath, 'bth', bth, 'solver', solver);
[Aopt, Adeg] = pqp.enumerateActiveSets();
assert(Aopt(1, 1)~=0); % AS=[] is not feasible!

sol = pqp.solve();
sol.xopt.plot
assert(sol.xopt.Num==12); % 10 non-overlapping or 12 with overlaps

solver = 'enumpqp';
pqp = Opt('H', H, 'A', A, 'b', b, 'pB', pB, 'Ath', Ath, 'bth', bth, 'solver', solver);
[Aopt, Adeg] = pqp.enumerateActiveSets();
sol = pqp.solve();
sol.xopt.plot
assert(sol.xopt.Num==12); assert(sol.xopt.Num==12); % 10 non-overlapping or 12 with overlaps

solver = 'plcp';
pqp = Opt('H', H, 'A', A, 'b', b, 'pB', pB, 'Ath', Ath, 'bth', bth, 'solver', solver);
[Aopt, Adeg] = pqp.enumerateActiveSets();
sol = pqp.solve();
assert(sol.xopt.Num==10);
sol.xopt.plot

%% mpt_mpqp is known to fail
% solver = 'mpqp';
% pqp = Opt('H', H, 'A', A, 'b', b, 'pB', pB, 'Ath', Ath, 'bth', bth, 'solver', solver);
% [Aopt, Adeg] = pqp.enumerateActiveSets();
% sol = pqp.solve();
% assert(sol.xopt.Num==10);
% sol.xopt.plot

end
