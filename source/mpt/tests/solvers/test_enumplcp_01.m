function test_enumplcp_01
% compares ENUMPLCP solution versus PLCP solver on a problem with 5
% parameters an 30 inequality constraints
%

load data_enumplcp_01

problem = Opt(M);
problem.solver='PLCP';
res1 = problem.solve;


problem.solver='ENUMPLCP';
res2 = problem.solve;


% analyse the solutions

% identify which regions are missing
list=zeros(1,res1.xopt.Num);
lc = list;
r =  list;
for i=1:res1.xopt.Num
    % get point inside the set
    xc = res1.xopt.Set(i).Internal.ChebyData.x;
    r(i) = res1.xopt.Set(i).Internal.ChebyData.r;
    
    % find corresponding set in the second solution
    [isin, inwhich, closest]= res2.xopt.contains(xc);
    if isin
        list(i) = inwhich(1);
    else
        lc(i) = closest;        
    end
end

% check the radious of the inscribed ball inside the missing regions
idm = find(lc);
if any(r(idm)>1e-4)
    error('The radius of the missing regions exceeds tolerance 1e-4.')
end

end