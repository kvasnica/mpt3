function test_qp_solvers14(solver,tol)
%
% test provided by Michal
%

load data_test_qp11

o = Opt('H', H, 'f', f, 'A', A, 'b', B, 'Ae', Aeq, 'be', Beq,'solver',solver);
sol = o.solve();

[~,~,~,~,lambda] = quadprog(H,f,A,B,Aeq,Beq,[],[],[],optimset('Display','off'));

if norm(sol.lambda.ineqlin-lambda.ineqlin,Inf)>tol
    error('Lagrange multipliers for inequalities do not hold.');    
end

% no equalities are present - don't need to check
% if norm(sol.lambda.eqlin-lambda.eqlin,Inf)>tol
%     error('Lagrange multipliers for equalities do not hold.');    
% end


end