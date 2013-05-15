function test_polyunion_trim_01_pass
% Tests Union/trimFunction

N = 3; nu = 1; nx = 2;
Double_Integrator;
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, N);
assert(E.nr==19);

funs = E.optimizer.listFunctions;

% check that we generated full open-loop optimizer
for i = 1:E.optimizer.Num
	f = E.optimizer.Set(i).getFunction('primal');
	assert(isa(f, 'AffFunction'));
	assert(f.D==nx);
	assert(f.R==N*nu);
	assert(isequal(size(f.F), [N*nu nx]));
	assert(isequal(size(f.g), [N*nu 1]));
	
	f = E.optimizer.Set(i).getFunction('obj');
	assert(isa(f, 'QuadFunction'));
	assert(isequal(size(f.H), [nx nx]));
	assert(isequal(size(f.F), [1 nx]));
	assert(isequal(size(f.g), [1 1]));
end

% now trim the open-loop optimizer (in-place trimming)
nu_trim = 1;
G = E.optimizer.copy;
G.trimFunction('primal', nu_trim); % should do in-place trimming
% functions should be the same as before
assert(isequal(G.listFunctions, funs));
% original function should be unchanged
for i = 1:E.optimizer.Num
	f = E.optimizer.Set(i).getFunction('primal');
	assert(isa(f, 'AffFunction'));
	assert(f.D==nx);
	assert(f.R==N*nu);
	assert(isequal(size(f.F), [N*nu nx]));
	assert(isequal(size(f.g), [N*nu 1]));
end
% new function should be trimmed
for i = 1:G.Num
	f = G.Set(i).getFunction('primal');
	g = E.optimizer.Set(i).getFunction('primal');
	assert(isa(f, 'AffFunction'));
	assert(f.D==nx);
	assert(f.R==nu_trim);
	assert(isequal(size(f.F), [nu_trim nx]));
	assert(isequal(size(f.g), [nu_trim 1]));
	assert(isequal(g.F(1:nu_trim, :), f.F));
	assert(isequal(g.g(1:nu_trim), f.g));
end

% now trim the open-loop optimizer (create a new function)
nu_trim = 1;
G = E.optimizer.trimFunction('primal', nu_trim); % should create a new function
% functions should be the same as before
assert(isequal(G.listFunctions, funs));
% original function should be unchanged
for i = 1:E.optimizer.Num
	f = E.optimizer.Set(i).getFunction('primal');
	assert(isa(f, 'AffFunction'));
	assert(f.D==nx);
	assert(f.R==N*nu);
	assert(isequal(size(f.F), [N*nu nx]));
	assert(isequal(size(f.g), [N*nu 1]));
end
% new function should be trimmed
for i = 1:G.Num
	f = G.Set(i).getFunction('primal');
	g = E.optimizer.Set(i).getFunction('primal');
	assert(isa(f, 'AffFunction'));
	assert(f.D==nx);
	assert(f.R==nu_trim);
	assert(isequal(size(f.F), [nu_trim nx]));
	assert(isequal(size(f.g), [nu_trim 1]));
	assert(isequal(g.F(1:nu_trim, :), f.F));
	assert(isequal(g.g(1:nu_trim), f.g));
end

% now trim the open-loop optimizer to 2*nu
nu_trim = 2;
G = E.optimizer.copy;
G.trimFunction('primal', nu_trim);
% functions should be the same as before
assert(isequal(G.listFunctions, funs));
% original function should be unchanged
for i = 1:E.optimizer.Num
	f = E.optimizer.Set(i).getFunction('primal');
	assert(isa(f, 'AffFunction'));
	assert(f.D==nx);
	assert(f.R==N*nu);
	assert(isequal(size(f.F), [N*nu nx]));
	assert(isequal(size(f.g), [N*nu 1]));
end
% new function should be trimmed
for i = 1:G.Num
	f = G.Set(i).getFunction('primal');
	g = E.optimizer.Set(i).getFunction('primal');
	assert(isa(f, 'AffFunction'));
	assert(f.D==nx);
	assert(f.R==nu_trim);
	assert(isequal(size(f.F), [nu_trim nx]));
	assert(isequal(size(f.g), [nu_trim 1]));
	assert(isequal(g.F(1:nu_trim, :), f.F));
	assert(isequal(g.g(1:nu_trim), f.g));
end
