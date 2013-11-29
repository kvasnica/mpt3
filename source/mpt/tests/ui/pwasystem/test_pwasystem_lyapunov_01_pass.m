function test_pwasystem_lyapunov_01_pass

Double_Integrator;
model = mpt_import(sysStruct, probStruct);
ctrl = EMPCController(model, 5);
sys = ClosedLoop(ctrl, model).toSystem();

L = sys.lyapunov('pwq');

% check whether the function decreases along closed-loop trajectory
for i = 1:sys.ndyn
    X = sys.domain(i).grid(20);
    for j = 1:size(X, 1)
        x = X(j, :)';
        xp = sys.A{i}*x+sys.f{i};
        Lx = L.feval(x, 'tiebreak', 'lyapunov');
        Lp = L.feval(xp, 'tiebreak', 'lyapunov');
        assert(Lx>=1e-8*x'*x); % positivity
        assert(Lp<Lx); % decrease
    end
end

end
