function test_enumplcp_03
% testing hybrid MPC with equality constraints on binary variables

A1 = [1, 0.5; -2.3, 0.9];
B1 = [0.8; -3.4];
model1 = LTISystem('A',A1,'B',B1);
% x1<=0
D1 = Polyhedron([1 0],0);
model1.setDomain('x',D1);

A2 = [-2, 1.2; -4.1, -3.1];
B2 = [0.1; -2.1];
model2 = LTISystem('A',A2,'B',B2);
% x1>=0
D2 = Polyhedron([-1 0],0);
model2.setDomain('x',D2);

% pwa model
pwa_model = PWASystem([model1, model2]);
pwa_model.x.min = [-9;-10];
pwa_model.x.max = [7; 8];
pwa_model.u.min = -2;
pwa_model.u.max = 3;

pwa_model.x.penalty = QuadFunction(eye(2));
pwa_model.u.penalty = QuadFunction(0.1);


ctrl = MPCController(pwa_model, 2);
d = ctrl.toYALMIP;

problem = Opt(d.constraints, d.objective, d.internal.parameters, d.internal.requested);

% solve using PLCP solver and YALMIP
c = solvemp(d.constraints, d.objective,[],d.internal.parameters, d.internal.requested);
xopt = mpt_mpsol2pu(c);
U1 = PolyUnion([xopt.Set]);

% solve using ENUMPLCP solver
sol = mpt_call_enum_plcp(problem);
U2 = sol.xopt;

% verify correctnes evaluating the primal value for each region
for i=1:U1.Num
    xg = U1.Set(i).grid(5);
    for j=1:size(xg,1)
        x = xg(j,:)';
        u1 = U1.feval(x,'primal','tiebreak','obj');
        u2 = U2.feval(x,'primal','tiebreak','obj');
        
        % check the primal solution
        if norm(u1-u2,Inf)>1e-4
            % if the primal solution does not hold, check the cost
            obj1 = U1.feval(x,'obj','tiebreak','obj');
            obj2 = U2.feval(x,'obj','tiebreak','obj');
            if norm(obj1-obj2,Inf)>1e-4
                error('The solutions do not hold.');
            end
        end
    end
end
    

end


