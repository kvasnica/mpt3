function test_qp_MPC
%
% compares speed of solving various MPC problems with QP solvers

global MPTOPTIONS

disp('Testing speed of solvers with 10 MPC examples:');
load MPCdata

settings = mptopt;
QPsolvers = settings.solvers_list.QP;
total_time = zeros(1,length(QPsolvers));
infeasible = total_time;

for k=1:length(QPsolvers)
    disp(['testing ',QPsolvers{k},' solver...']);
    for i=1:length(QP.n)
                
        % construct problem
        S.H = QP.H{i};
        S.f = QP.F{i}'*QP.x0{i};
        S.A = QP.G{i};
        S.b = QP.W{i} + QP.E{i}*QP.x0{i};
        S.solver = QPsolvers{k};

        % solve one problem N times to get averaged computational time
        N=50;
        Rm=cell(1,N);
        tm = zeros(1,N);
        for j=1:N
            t0 = cputime;
            Rm{j} = mpt_solve(S);
            tm(j) = cputime-t0;
        end
        
        % prepare matrices for output
        res.(QPsolvers{k}).n(i) = size(QP.H{i},1);
        res.(QPsolvers{k}).m(i) = size(QP.G{i},1);
        res.(QPsolvers{k}).R{i} = Rm{1};
        res.(QPsolvers{k}).avg_time(i) = mean(tm);
    end
    
    % count how many times solver was not feasible
    for i=1:length(QP.n)
        if res.(QPsolvers{k}).R{i}.exitflag~=MPTOPTIONS.OK
            infeasible(k) = infeasible(k)+1;
        end
    end
    
    % sum up computational times for each solver
    res.(QPsolvers{k}).total_time = sum(res.(QPsolvers{k}).avg_time);
    total_time(k) = sum(res.(QPsolvers{k}).avg_time);

    
end

[yy, ind] = sort(total_time);
res.total_time = yy;
res.solvers_list = QPsolvers(ind);
res.infeasible = infeasible(ind);

disp('Time spent on solving MPC problems.');
for i=1:length(total_time)
   disp([res.solvers_list{i},' ',num2str(res.total_time(i)),'s (infeasible ',num2str(res.infeasible(i)),'-times)']); 
end

