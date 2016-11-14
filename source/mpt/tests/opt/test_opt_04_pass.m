function test_opt_04_pass
%
% opt constructor test
% 
% 

% parametric QP

problem=Opt('H',[1 0.5;0.5 1],'A',[1 -3],'b',5,'pF',[3;-1],'pB',1,'Ath',[-1;1],'bth',[10;10]);

r=problem.solve;

if r.xopt.Num~=4
    error('Wrong number of regions.');
end

end