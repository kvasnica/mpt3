function test_opt_solve_03_pass
%
% infeasible problem - parametric solvers should report infeasible status
%

global MPTOPTIONS

f = [-0.24218; 0.96848; -0.35388];
A = [ 2.3612     -0.66375      -1.5129;
      0.82398        0.193      -1.0292;
     -0.72512      0.57454     -0.66414;
      0.19356       1.1199     -0.77319;
      -1.6731       2.4611     -0.63043];
b = [0.87061; 4.1989; 3.4993; 4.4747; 1.1412];
pB =[0.12992     0.017498; 
     1.6943     -0.49123;
     0.11376     -0.36054;
    -1.7172     -0.25931;
     1.4273      0.70709];
Ath = [eye(2);-eye(2)];
bth = [5;5;3;3];

for i=transpose(MPTOPTIONS.solvers_list.parametric.LP)

    problem = Opt('f',f,'A',A,'b',b,'pB',pB,'Ath',Ath,'bth',bth,'solver',i{1});
    res = problem.solve;
    if res.exitflag~=MPTOPTIONS.INFEASIBLE
        error('The reported solution must have infeasible status');
    end
end

for i=transpose(MPTOPTIONS.solvers_list.parametric.QP)

    problem = Opt('H',diag([1,1,1]),'f',f,'A',A,'b',b,'pB',pB,'Ath',Ath,'bth',-bth,'solver',i{1});
    res = problem.solve;
    if res.exitflag~=MPTOPTIONS.INFEASIBLE
        error('The reported solution must have infeasible status');
    end
end


end