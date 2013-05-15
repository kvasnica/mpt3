function test_opt_12_pass
%
% opt constructor test
% 
% 

% must parse structure with empty vars

S.H = 1;
S.f = 0;
S.lb = -10;
S.A = [];
S.b = [];
Opt(S);