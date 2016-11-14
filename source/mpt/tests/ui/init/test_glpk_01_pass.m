function test_glpk_01_pass
% make sure GLPK works

H = 1;
f = 1;
A = [1;-1];
b = [1;1];
lb = 0;
test = true;

solver = 'GLPK';
S = struct('solver',solver,'test',test,'f',f,'A',A,'b',b,'lb',lb,'vartype','B');

R = mpt_solve(S);

end
