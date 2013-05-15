function test_opt_19_pass
%
% opt constructor test
% MILP
% 

% solution = 1
A = [1; -1];
b = [2; 2];
f = -1;
vartype = 'B';
p = Opt('A', A, 'b', b, 'f', f, 'vartype', vartype);

r = p.solve;
if r.xopt~=1
    error('The solution here is 1.');
end

S = struct('A', A, 'b', b, 'f', f, 'vartype', vartype);

rn = mpt_solve(S);
if rn.xopt~=1
    error('The solution here is 1.');
end

end