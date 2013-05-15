function test_opt_10_pass
%
% opt constructor test
% 
% 

% include polyhedron to LCP
P = Polyhedron('lb',[-1 -1],'ub',[10;20]);
Opt('P',P,'M',randn(4),'q',rand(4,1),'Q',randn(4,2),'Ath',[eye(2);-eye(2)],'bth',ones(4,1));