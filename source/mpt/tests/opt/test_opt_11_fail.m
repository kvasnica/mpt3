function test_opt_11_fail
%
% opt constructor test
% wrong solver

% include polyhedron to LCP
P = Polyhedron('lb',[-1 -1],'ub',[10;20]);
Opt('P',P,'M',randn(4),'q',rand(4,1),'Q',randn(4,2),'solver','mplp');