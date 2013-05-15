function sol = chebyCenter(P, facetI, bound)
% Compute the cheby-center
%
% If facetI is specified, then set facetI inequalities to equality
%
% sol:
%  x       - cheby center (or [])
%  r       - radius (or -inf)
%  exitflag    - optimizer return status
%
% Notes
% - Bounds radius by bound if given
% - Can only compute if there is an Hrep
%


global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

if nargin < 2,
	facetI = [];
	bound = Inf;
elseif ~isempty(facetI)
	% check if facet is vector of indices
	validate_indexset(facetI);
end
if nargin < 3,
    bound = Inf;
else
    if ~isscalar(bound)
        error('Upper bound the the radius must be scalar.');
    end
    if ~isnumeric(bound) || bound<=0 || ~isreal(bound) || isnan(bound)
       error('Upper bound on the radius must be a numeric real scalar, positive valued.');
    end
end

%% deal with arrays
if length(P)>1
    sol = cell(size(P));
    parfor i=1:length(P)
        sol{i} = chebyCenter(P(i), facetI, bound);
    end
    return;
end

%% checks for polyhedra
if ~P.hasHRep
	if ~P.hasVRep
		% empty polyhedron
		sol.exitflag = MPTOPTIONS.INFEASIBLE;
		sol.x = [];
		sol.r = -inf;
		return;
	end
	% get the Hrep
	P.minHRep();
end

H = P.H_int; He = P.He_int;

% if facets provided, P must be irredundant
if ~isempty(facetI)
    if ~P.irredundantHRep
        error('Polyhedron must be in minimal representation when you want compute Chebyshev centre any of its facets. Use "minHRep()" to compute the facets.');
    end
end

%% if Chebyshev data are stored internally, use this information
if isfield(P.Internal,'ChebyData') && isempty(facetI) && isinf(bound)
    
    % only available if there is no facet and bound provided
    if ~isempty(P.Internal.ChebyData)
        sol = P.Internal.ChebyData;
        return
    end
end

% Chebyshev centre solves a following LP:
%
%    max r
% s.t.:   a_i'*xc + ||a_i||_2*r <= b_i    i=1,...,m
%         Ae*xc = be
%
% where a_i is the i-th row of the inequality matrix A in A*xc<=b and
% ||a_i||_2 is the 2-norm of that row


% inequality constraints on [xc, r]
% [ a_i, ||a_i||_2 ], i=1,...,m
A = H(:, 1:end-1);
S.A  = [A sqrt(sum(A.*A,2))];
S.b = H(:, end);

% equality constraints
% [ a_i   0 ], i=1, ..., me
Ae = He(:, 1:end-1);
S.Ae = [Ae zeros(size(Ae,1),1)];
S.be = He(:, end);

% if we want to compute center of the facet, add this facet to equality
% constraints
if ~isempty(facetI)
    if any(facetI > size(S.A,1))
        error('Facet index must be less than number of inequalities (%i).', size(S.A,1));
    end
    S.Ae = [S.Ae;S.A(facetI,1:end-1) zeros(length(facetI),1)];
    S.be = [S.be;S.b(facetI)];
    S.A(facetI,:) = [];
    S.b(facetI,:) = [];
end

% lower bounds on [xc, r]
S.A = [S.A; zeros(1,P.Dim), -1];
S.b = [S.b; 0];
% upper bounds
if ~isinf(bound)
    S.A = [S.A; zeros(1,P.Dim), 1];
    S.b = [S.b; bound];
end

% the last value is -1 because it is maximization
S.f = [zeros(size(H, 2)-1,1);-1];

% solve problem
S.lb = []; S.ub = []; S.quicklp = true;
ret = mpt_solve(S);

% set output variables
sol.exitflag = ret.exitflag;

if ret.exitflag == MPTOPTIONS.OK
    if -ret.obj>MPTOPTIONS.zero_tol
        sol.x = ret.xopt(1:end-1);
        sol.r = ret.xopt(end);
    else
        sol.x = ret.xopt(1:end-1);
        sol.r = 0;
    end
else
    % Solution can be unbounded/infeasible. This is not a problem for
    % unbounded polyhedra. A simple remedy is to put bound on the radius to
    % get feasible result but we mark the radius as Inf.
    
    S.A = [S.A; zeros(1,P.Dim), 1];
    S.b = [S.b; 1];

    % solve problem
    ret = mpt_solve(S);
    
    if ret.exitflag == MPTOPTIONS.OK
        sol.exitflag = MPTOPTIONS.OK;
        sol.x = ret.xopt(1:end-1);
        sol.r = Inf;
    else
        % infeasible
        sol.x = [];
        sol.r = -Inf;
    end
end





% store internally if empty facet and the bound is provided
if isempty(facetI) && isinf(bound)
    P.Internal.ChebyData = sol;
end



end
