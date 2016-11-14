function test_polyunion_min_03_pass
% test for PolyUnion/min using a PWA cost

opt_sincos; probStruct.N = 2;
sysStruct.xmax = 1.5*[1;1];
sysStruct.xmin = 1.5*[-1; -1];
model = mpt_import(sysStruct, probStruct);
if ~model.x.hasFilter('terminalPenalty')
	model.x.with('terminalPenalty');
	model.x.terminalPenalty = model.x.penalty;
end
mpc = MPCController(model, probStruct.N);
ctrl = mpc.toExplicit;
PUs = ctrl.optimizer;

Q = PUs.min('obj');
% assert(Q.Num>=28);

newctrl = EMPCController(Q);
newctrl.nu = ctrl.nu;
newctrl.N = ctrl.N;

% state dimension should be automatically determined based on dimension of
% regions
assert(newctrl.nx==ctrl.nx);

tested = 0;
% check that cost and optimizers are correct
for i = 1:numel(newctrl.optimizer.Set)
	fprintf('Verifying cost in region %d out of %d...\n', ...
		i, numel(newctrl.optimizer.Set));
	
	% grid each region
	[x, y] = newctrl.optimizer.Set(i).meshGrid(2);
	
	for row = 1:size(x, 1)
		for col = 1:size(x, 2)
			if isnan(x(row, col)) || isnan(y(row, col))
				continue
			end
			
			tested = tested+1;
			point = [x(row, col); y(row, col)];
			[Uonl, Jonl] = mpc.evaluate(point);
			[Uexp, Jexp] = ctrl.evaluate(point);
			[Umin, Jmin] = newctrl.evaluate(point);
			
			% we would love to compare the full optimizer, but there might
			% be issues with non-uniqueness
			assertwarning(norm(Uonl-Uexp)<1e-10);
			assert(norm(Uexp-Umin)<1e-10);
			assert(norm(Jonl-Jexp)<1e-8);
			assert(norm(Jonl-Jmin)<1e-8);
			
		end
	end
end

fprintf('%d points tested.\n', tested);
assert(tested>100);

end
