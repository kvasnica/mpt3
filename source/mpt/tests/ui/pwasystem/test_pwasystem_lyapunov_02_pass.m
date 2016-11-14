function test_pwasystem_lyapunov_02_pass

model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.u.min = -1;
model.u.max = 1;
model.x.min = [-5; -5];
model.x.max = [5; 5];
model.u.penalty = OneNormFunction(1);
model.x.penalty = OneNormFunction(eye(2));
model.x.with('terminalSet');
model.x.terminalSet = Polyhedron.unitBox(2)*0.5;
model.x.with('terminalPenalty');
model.x.terminalPenalty = OneNormFunction(eye(2));
N = 2;
ctrl = MPCController(model, N).toExplicit();
loop = ClosedLoop(ctrl, model);
sys = loop.toSystem();

L = sys.lyapunov('pwa');

% check whether the function decreases along closed-loop trajectory
for i = 1:sys.ndyn
    X = sys.domain(i).grid(20);
    for j = 1:size(X, 1)
        x = X(j, :)';
        xp = sys.A{i}*x+sys.f{i};
        Lx = L.feval(x, 'tiebreak', 'lyapunov');
        Lp = L.feval(xp, 'tiebreak', 'lyapunov');
        assert(Lx>=1e-8*norm(x, 1)); % positivity
        assert(Lp<=Lx); % decrease
    end
end

end
