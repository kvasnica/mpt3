function R = mpt_call_gurobi(S)
%
% header file to be inserted from XML source

global MPTOPTIONS
if isempty(MPTOPTIONS) && ~S.test
    MPTOPTIONS = mptopt;
end

if strcmpi(S.problem_type,'LCP')
    error('mpt_call_gurobi: GUROBI solver does not solve %s problems!',S.problem_type);
end


% merge constraints, must be in sparse format
A = sparse([S.Ae; S.A]);
b = full([S.be; S.b]);
% constraint types, accepts "<", ">", "=" chars
ctypes = char(['='*ones(S.me,1); '<'*ones(S.m,1)]);


% merge lb/ub with inequality constraints
% detect Inf boundaries
if S.test
    ilb = (S.lb==-Inf) | (S.lb<=-1e6);
    iub = (S.ub==Inf)  | (S.ub>=1e6);
else
    ilb = (S.lb==-Inf) | (S.lb<=-MPTOPTIONS.infbound);
    iub = (S.ub==Inf)  | (S.ub>=MPTOPTIONS.infbound);
end
% store kept rows
kept_rows.lb = find(~ilb);
kept_rows.ub = find(~iub);
if any(~ilb)
    % put ones at the positions where there is lb/ub
    Alb = zeros(nnz(~ilb),S.n);
    Alb(:,~ilb) = -speye(nnz(~ilb));
    A = [A; Alb];
    b = [b; -S.lb(~ilb)];
    ctypes = [ctypes; '<'*ones(nnz(~ilb),1) ];
end
if any(~iub)
    Aub = zeros(nnz(~iub),S.n);
    Aub(:,~iub) = speye(nnz(~iub));
    A = [A; Aub];
    b = [b; S.ub(~iub)];
    ctypes = [ctypes; '<'*ones(nnz(~iub),1) ]; 
end

% option description can be found:
%   http://www.gurobi.com/doc/20/refman/node378.html
%
if ~S.test
    opts = MPTOPTIONS.modules.solvers.gurobi;
else
    opts.IterationLimit = 1e3;
    opts.FeasibilityTol = 1e-6;
    opts.IntFeasTol = 1e-5;
    opts.OptimalityTol = 1e-6;
    opts.Method = 1;         % 0=primal simplex, 1=dual simplex, 2=barrier, 3=concurrent, 4=deterministic concurrentx
    opts.Presolve = -1;        % -1 - auto, 0 - no, 1 - conserv, 2 - aggressive
    % complete silence
    opts.OutputFlag= 0;
end

if isfield(S, 'quicklp') || isfield(S, 'quickqp')
    % prevent gurobi from returning the INF_OR_UNBD status:
    % http://www.gurobi.com/documentation/5.6/reference-manual/infunbdinfo
    opts.InfUnbdInfo=1;
end

% put arguments to a struct
model.A = A;
model.rhs = b;
model.sense = ctypes;
model.lb = -Inf(S.n,1);
model.ub = Inf(S.n,1);
if ~isempty(S.vartype)
    model.vtype = S.vartype;
end
model.obj = S.f;

if any(strcmpi(S.problem_type,{'QP','MIQP'}))
    model.Q = sparse(S.H*0.5);
end

% do LP and MILP first (do not require quadratic terms in opts)
if any(strcmpi(S.problem_type,{'LP','QP'}))
    %[R.xopt,R.obj,flag,output,lambda] = gurobi_mex(S.f, 1, A, b, ctypes, lb, ub, S.vartype, opts);    
    result = gurobi(model,opts);
    if isfield(result,'pi')
        lam = -result.pi;
    else
        lam = NaN(size(A,1),1);
    end
elseif any(strcmpi(S.problem_type,{'MILP','MIQP'}))
    % GUROBI gives no lambda (Pi) for MIPs.
    %[R.xopt,R.obj,flag,output] = gurobi_mex(S.f, 1, A, b, ctypes, lb, ub, S.vartype, opts);
    result = gurobi(model,opts);
    lam = NaN(size(A,1),1);
end
if isfield(result,'x')
    R.xopt = result.x;
else
    % in case no output is returned, make zero output to at least match the
    % dimension
    R.xopt = S.x0;
end
if isfield(result,'objval')
    R.obj = result.objval;
else
    R.obj = 0;
end


% assign Lagrange multipliers
if isempty(lam)
   R.lambda.ineqlin = [];
   R.lambda.eqlin = [];
   R.lambda.lower = [];
   R.lambda.upper = [];
else
    R.lambda.ineqlin = lam(S.me+1:S.me+S.m);
    R.lambda.eqlin = lam(1:S.me);    
    if ~isempty(S.lb)
        R.lambda.lower = zeros(S.n,1);
        R.lambda.lower(kept_rows.lb) = lam(S.me+S.m+1:S.me+S.m+numel(kept_rows.lb));
    else
        R.lambda.lower = zeros(S.n,1);
    end
    if ~isempty(S.ub) && isempty(S.lb)
        R.lambda.upper = zeros(S.n,1);
        R.lambda.upper(kept_rows.ub) = lam(S.me+S.m+1:S.me+S.m+numel(kept_rows.ub));
    elseif ~isempty(S.ub) && ~isempty(S.lb)
        R.lambda.upper = zeros(S.n,1);
        R.lambda.upper(kept_rows.ub) = lam(S.me+S.m+numel(kept_rows.lb)+1:S.me+S.m+numel(kept_rows.lb)+numel(kept_rows.ub));
    else
        R.lambda.upper = zeros(S.n,1);
    end    
end

switch result.status
    case 'LOADED'
        R.how = 'not started';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'OPTIMAL'
        R.how = 'ok';
        if S.test
            R.exitflag = 1;
        else
            R.exitflag = MPTOPTIONS.OK;
        end
    case 'INFEASIBLE'
        R.how = 'infeasible';
        if S.test
            R.exitflag = 2;
        else
            R.exitflag = MPTOPTIONS.INFEASIBLE;
        end
    case 'INF_OR_UNBD'
        R.how = 'infeasible or unbounded';
		
		% according to the docs we should switch off presolve:
		% http://www.gurobi.com/documentation/4.6/example-tour/node77
		opts.Presolve = 0; % 0 = off
		result = gurobi(model, opts);
		switch result.status,
			case {'OPTIMAL', 'UNBOUNDED'}
				if S.test
					R.exitflag = 3;
				else
					R.exitflag = MPTOPTIONS.UNBOUNDED;
				end
				R.how = 'unbounded';
				
				% do not forget to update the optimizer
				if isfield(result, 'x')
					R.xopt = result.x;
				end
				if isfield(result, 'objval')
					R.obj = result.objval;
				end
			otherwise
				if S.test
					R.exitflag = 2;
				else
					R.exitflag = MPTOPTIONS.INFEASIBLE;
				end
				R.how = 'infeasible';
		end
    case 'UNBOUNDED'
        R.how = 'unbounded';
        if S.test
            R.exitflag = 3;
        else
            R.exitflag = MPTOPTIONS.UNBOUNDED;
        end
    case 'CUTOFF'
        R.how = 'objective worse than specified cutoff';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'ITERATION_LIMIT'
        R.how = 'reaching iteration limit';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'NODE_LIMIT'
        R.how = 'reaching node limit';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'TIME_LIMIT'
        R.how = 'reaching time limit';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'SOLUTION_LIMIT'
        R.how = 'reaching solution limit';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'INTERRUPTED'
        R.how = 'user interruption';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'NUMERIC'
        R.how = 'numerical difficulties';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'SUBOPTIMAL'
        R.how = 'suboptimal solution';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    otherwise
        R.how = result.status;
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
end

end
