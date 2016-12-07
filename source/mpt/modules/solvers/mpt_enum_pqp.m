function sol = mpt_enum_pqp(pqp, options)
% Enumeration-based parametric QP (pQP) solver
%
% Solves a strictly convex pQP by explicit enumeration of all active sets:
%
%    min_z 0.5*z'*H*z + (pF*x+f)'*z + x'*Y*x + C'*x + c
%     s.t.   A*z <=  b + pB*x
%           Ae*z == be + pE*x
%          Ath*x <= bth
%             lb <= z <= ub
%
% NOTE: the enumeration-based approach is only suitable for problems with a
%       small number of optimization variables, typically with length(z)<8.
%
% Syntax:
% -------
%
%   sol = mpt_enum_pqp(pqp, options)
%
% Inputs:
% -------
%       pqp: pQP problem formulated as an Opt object
%   options: structure of options
%              .regions: if true, critical regions will be created
%                        (default=true)
%     .prune_infeasible: if true, list of candidate active sets is pruned
%                        by removing entries that were previously
%                        discovered as infeasible (default=true)
%         .feasible_set: if 'projection', the set of feasible parameters is
%                        computed by projection. If 'regions', the set is
%                        calculcated by exploring which facets of critical
%                        regions are at the boundary of the feasible set.
%                        If 'outerbox', the feasible set is costructed as the
%                        outer box approximation of the union of critical
%                        regions. (default='regions')
%     .remove_redundant: if true, redundant inequalities will be detected
%                        and removed from the pQP (default=true)
%              .verbose: if >=0, progress will be displayed (default=0)
%
% Outputs:
% --------
%    sol.xopt: the parametric solution as a PolyUnion
%     sol.how: string indication of feasibility
%
% Literature:
% -----------
%  Gupta, A., Bhartiya, S., Nataraj, P.S.V.: 
%  A novel approach to multiparametric quadratic programming. 
%  Automatica, vol. 47, pp. 2112-2117, 2011
%
%  Kvasnica, M., Takacs, B., Holaza, J., Di Cairano, S.:
%  On Region-Free Explicit Model Predictive Control.
%  In 54rd IEEE Conference on Decision and Control,
%  vol. 54, pp. 3669?3674, 2015.

% Copyright is with the following author(s):
%
% (C) 2013-2016 Michal Kvasnica, STU Bratislava, michal.kvasnica@stuba.sk

% ---------------------------------------------------------------------------
% Legal note:
%          This program is free software; you can redistribute it and/or
%          modify it under the terms of the GNU General Public
%          License as published by the Free Software Foundation; either
%          version 2.1 of the License, or (at your option) any later version.
%
%          This program is distributed in the hope that it will be useful,
%          but WITHOUT ANY WARRANTY; without even the implied warranty of
%          MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%          General Public License for more details.
%
%          You should have received a copy of the GNU General Public
%          License along with this library; if not, write to the
%          Free Software Foundation, Inc.,
%          59 Temple Place, Suite 330,
%          Boston, MA  02111-1307  USA
%
% ---------------------------------------------------------------------------

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS=mptopt;
end

if nargin<2
    options = [];
end
options = mpt_defaultOptions(options, ...
    'verbose', MPTOPTIONS.verbose, ...
    'prune_infeasible', MPTOPTIONS.modules.solvers.enum_pqp.prune_infeasible, ...
    'feasible_set', MPTOPTIONS.modules.solvers.enum_pqp.feasible_set, ...
    'regions', true, ...
    'remove_redundant', MPTOPTIONS.modules.solvers.enum_pqp.remove_redundant, ...
    'report_period', MPTOPTIONS.report_period, ...
    'exclude', {});

if ~isa(pqp, 'Opt')
    error('The first input must be an instance of the Opt class.');
elseif ~isequal(lower(pqp.problem_type), 'qp') || ~pqp.isParametric
    error('The first input must be a parametric QP.');
end

if ~options.regions && ~isequal(options.feasible_set, 'Rn')
    fprintf('Forcing options.feasible_set=''Rn''.\n');
    options.feasible_set = 'Rn';
end

% eliminate equalities, keep the original setup
pqp_orig = pqp.copy();
if pqp.me>0
    fprintf('Eliminating equalities... ');
    pqp.eliminateEquations();
    fprintf('done\n');
end
if options.regions
    region_options = [];
else
    region_options.regionless = true;
    region_options.pqp_with_equalities = pqp_orig;
end

m_before = pqp.m;
if options.remove_redundant
    % remove redundant inequalities
    pqp.minHRep();
end

if min(eig(pqp.H)) < MPTOPTIONS.rel_tol
    error('The pQP must be strictly positive definite. mineig(H)=%g must be >%g.', ...
        min(eig(pqp.H)), MPTOPTIONS.rel_tol);
end

if options.verbose>=0
    fprintf('Parameters: %d, variables: %d, inequalities: %d', ...
        pqp.d, pqp.n, pqp.m);
    if options.remove_redundant
        fprintf(' (reduced from %d)', m_before);
    end
    fprintf('\n');
    upperbound = 0;
    for i = 0:pqp.n
        upperbound = upperbound + nchoosek(pqp.m, i);
    end
    fprintf('Upper bound on the number of regions: %d\n', upperbound);
end

start_time = clock;

%% get optimal active sets
start_t = clock;
if options.verbose>=0
    fprintf('Exploring active constraints...\n');
end
[Aopt, Adeg, Afeas, Ainfeas, nlps] = getActiveSets(pqp, options);
if options.verbose>0
    fprintf('...done (%.1f seconds, number of LPs: %d)\n', ...
        etime(clock, start_t), nlps);
end
% merge optimal and degenerate active sets
AS = [Aopt, Adeg];
n_total = 0;
for i = 1:length(AS)
    n_total = n_total + size(AS{i}, 1);
end

%% recover regions, optimizers and the cost function
regions = [];
n_lowdim = 0;
start_t = clock;
if options.verbose>=0
    if options.regions
        fprintf('Constructing regions and parametric optimizers...\n');
    else
        fprintf('Constructing parametric optimizers...\n');
    end
end
t = tic;
for i = 1:length(AS)
    for j = 1:size(AS{i}, 1)
        if options.verbose>=0 && toc(t) > options.report_period
            fprintf('progress: %d/%d\n', i, n_total);
            t = tic;
        end
        R = pqp.getRegion(AS{i}(j, :), region_options);
        if R.isEmptySet()
            n_lowdim = n_lowdim + 1;
        else
            if isempty(regions)
                regions = R;
            else
                regions(end+1) = R;
            end
        end
    end
    %regions = [regions, R];
end
if options.verbose>=0
    fprintf('...done (%.1f seconds)\n', etime(clock, start_t));
end
if options.verbose>=0 && n_lowdim > 0
    fprintf('WARNING: %d lower-dimensional regions discarded\n', n_lowdim);
end

%% create the output structure
if isempty(AS)
    % infeasible problem
    sol.xopt = PolyUnion;
    sol.exitflag = MPTOPTIONS.INFEASIBLE;
    sol.how = 'infeasible';

else
    % compute the set of feasible parameters
    start_t = clock;
    if options.verbose>=0
        fprintf('Constructing the feasible set...\n');
    end

    switch lower(options.feasible_set)
        case 'projection'
            K = pqp.feasibleSet();
        case 'regions'
            K = pqp.feasibleSet(regions);
        case 'outerbox'
            K = PolyUnion(regions).outerApprox();
        case 'rn'
            K = Polyhedron.fullSpace(pqp.d);
        otherwise
            error('Unknown settings "%s" for options.feasible_set.', ...
                options.feasible_set)
    end
    % eliminate redundancies
    K.minHRep();
    if options.verbose>=0
        fprintf('...done (%.1f seconds)\n', etime(clock, start_t));
    end

    % create the polyunion
    if options.regions
        bounded = all(regions.isBounded());
    else
        bounded = true;
    end
    sol.xopt = PolyUnion('Set', regions, ...
        'Domain', K, ...
        'Convex', true, ...
        'Overlaps', false, ...
        'Bounded', bounded, ...
        'Connected', true, ...
        'FullDim', true);
    if (K.isFullSpace() && ~isequal(lower(options.feasible_set), 'rn')) || ~K.isFullDim()
        fprintf('WARNING: construction of the feasible set failed, the solution may contain holes!\n')
    else
        sol.xopt.setInternal('convexHull', K);
    end
    
    sol.exitflag = MPTOPTIONS.OK;
    sol.how = 'ok';
end
sol.stats.solveTime = etime(clock, start_time);
sol.stats.nLPs = nlps;
sol.stats.Aoptimal = Aopt;
sol.stats.Adegenerate = Adeg;
sol.stats.Afeasible = Afeas;
sol.stats.Ainfeasible = Ainfeas;

%% display final statistics
if options.verbose>=0
    runtime = etime(clock, start_time);
    nr = length(regions);
    fprintf('\n');
    fprintf('           Runtime: %.1f sec (%.1f regions per second)\n', ...
        runtime, nr/runtime);
        
    fprintf(' Number of regions: %d (non-degenerate: %d, degenerate: %d)\n', ...
        nr, length(Aopt), length(Adeg));
end

end

%%
%--------------------------------------------------------------
function [Aopt, Adeg, Afeas, Ainfeas, nlps] = getActiveSets(pqp, options)
% Enumerates all optimal combinations of active sets
%
% Syntax:
% -------
%
%   [Aopt, Adeg, Afeas, nLPs] = mpt_enumpqp(pqp, options)
%
% Inputs:
% -------
%       pqp: pQP problem formulated as an Opt object
%   options: structure of options
%     .prune_infeasible: if true, list of candidate active sets is pruned
%                        by removing entries that were previously
%                        discovered as infeasible (default=true)
%     .verbose: if >=0, progress will be displayed (default=0)
%
% Outputs:
% --------
%      Aopt: cell array of optimal non-degenerate active sets
%      Adeg: cell array of optimal degenerate active sets
%     Afeas: vector of indices of feasible constraints
%      nLPs: number of LPs solved

start_t = clock;

% is the case with no active constraints optimal?
[feasible, nlps] = checkActiveSet(pqp, []);
if feasible
    % yep, include the case into list of non-degenerate optimal active sets
    Aopt = {0};
    Afeas = {0};
else
    % nope, start with an empty list
    Aopt = {[]};
    Afeas = {-1};
end
Adeg = {[]};
Ainfeas = {[]};

if options.verbose>=0
    fprintf('Level    Total Candidates Optimal Degenerate Feasible Infeasible Rankdef       LPs\n');
end

% since we have "nz" optimization variables and a strictly convex QP, at
% most "nz" constraints will be active at the optimum
for i = 1:pqp.n
    if options.verbose>=0
        fprintf('%2d/%2d', i, pqp.n);
    end
    % explore all nodes in this level, provide unique list of feasible
    % constraints and all previously discovered infeasible combinations
    [Ao, Ad, Af, Ai, nlp] = exploreLevel(pqp, i, Afeas{end}, Ainfeas, options);
    nlps = nlps + nlp;
    Aopt{i+1} = Ao;    % optimal active sets
    Adeg{i+1} = Ad;    % degenerate active sets
    Afeas{i+1} = Af;   % feasible active sets
    Ainfeas{i+1} = Ai; % infeasible active sets
end
fprintf('...done (%.1f seconds, %d LPs)\n', etime(clock, start_t), nlps);

end

%%
%--------------------------------------------------------------
function [Aopt, Adeg, Afeasible, Ainfeasible, nlps] = exploreLevel(pqp, level, feasible, infeasible, options)
% Checks feasibility/optimality of each n-combination of active constraints
%
% Syntax:
% -------
%
% [Ao, Ad, Af, Ai] = exploreLevel(pqp, level, feasible, infeasible, options)
%
% Inputs:
% -------
%             pqp: matrices of the pQP formulation
%           level: index of the level (integer)
%        feasible: cell array of feasible active sets at the previous level
%      infeasible: cell array of infeasible active sets at each level
% options.verbose: if >=0, progress will be displayed
%
% Outputs:
% --------
%           Ao: m-by-n matrix of optimal active sets (n=level)
%           Ad: m-by-n matrix of degenerate optimal active sets
%           Af: m-by-n matrix of non-optimal feasible active sets
%           Ai: m-by-n matrix of infeasible active sets
%               (includes rank-defficient active sets)
%         nlps: number of LPs solved on this level

AllFeasible = unique(feasible(:));
% pre-alocate arrays
Aopt = zeros(size(feasible, 1)*length(AllFeasible), level);
Adeg = zeros(size(feasible, 1)*length(AllFeasible), level);
Afeasible = zeros(size(feasible, 1)*length(AllFeasible), level);
Ainfeasible = zeros(size(feasible, 1)*length(AllFeasible), level);
n_feasible = 0; 
n_opt = 0;
n_deg = 0;
n_infeasible = 0;
n_rankdef = 0;
n_candidates = 0;
nlps = 0;
n_pruned = 0;
t=tic;
first_display = true;
for i = 1:size(feasible, 1)
    if level==1
        candidates = 1:pqp.m;
    else
        candidates = AllFeasible(AllFeasible>max(feasible(i, :)));
    end
    for j = candidates(:)'
        if level==1
            Atry = j;
        else
            Atry = [feasible(i, :), j];
        end
        
        % remove previously known infeasible combinations
        %
        % we only need to do this from the 3rd level upwards, since on the 2nd
        % level the lists of feasible and infeasible constraints are mutually
        % exclusive, hence nodes are not poluted by any infeasible constraints
        do_check = true;
        if level>2 && options.prune_infeasible
            % check if Atry contains any sequence listed in "infeasible"
            for j = 2:length(infeasible)
                m = ismembc(infeasible{j}, Atry); % fastest implementation
                if any(sum(m, 2)==size(infeasible{j}, 2))
                    % Atry contains all entries from at least one row of
                    % "infeasible", therefore it can be removed
                    do_check = false;
                    n_pruned = n_pruned+1;
                    break
                end
            end
        end
        if do_check
            n_candidates = n_candidates + 1;
            [result, nlp] = checkActiveSet(pqp, Atry);
            nlps = nlps+nlp;
            %  2: optimal, no LICQ violation
            %  1: optimal, LICQ violated
            %  0: feasible, but not optimal
            % -1: infeasible
            % -2: rank defficient
            % -3: undecided
            % split active sets into feasible/infeasible/optimal/degenerate
            if result>=0
                n_feasible = n_feasible+1;
                Afeasible(n_feasible, :) = Atry;
                if result==1
                    n_deg = n_deg + 1;
                    Adeg(n_deg, :) = Atry;
                elseif result==2
                    n_opt = n_opt + 1;
                    Aopt(n_opt, :) = Atry;
                end
            end
            if result<0
                n_infeasible = n_infeasible + 1;
                Ainfeasible(n_infeasible, :) = Atry;
                if result==-2
                    n_rankdef = n_rankdef + 1;
                end
            end
        end
    end
    if options.verbose>=0 && toc(t)>options.report_period
        if ~first_display
            fprintf(repmat('\b', 1, 9));
        end
        fprintf('%8d%%', min(100, ceil(100*i/size(feasible, 1))));
        t=tic;
        first_display = false;
    end
end
Afeasible = Afeasible(1:n_feasible, :);
Ainfeasible = Ainfeasible(1:n_infeasible, :);
Aopt = Aopt(1:n_opt, :);
Adeg = Adeg(1:n_deg, :);

if options.verbose>=0
    % delete progress meter
    if ~first_display
        fprintf(repmat('\b', 1, 9));
    end
    % display progress
    fprintf('%9d   %8d', n_candidates+n_pruned, n_candidates);
    fprintf('%8d   %8d %8d   %8d%8d  %8d\n', ...
        n_opt, n_deg, n_feasible-n_opt-n_deg, n_infeasible-n_rankdef, ...
        n_rankdef, nlps);
end

end

%%
%--------------------------------------------------------------
function [result, nlps] = checkActiveSet(pqp, A)
% Checks optimality/fesibility of a given active set
%
% pQP formulation:
%
%    min_z 0.5*z'*H*z + (pF*x+f)'*z + x'*Y*x + C'*x + c
%     s.t.   A*z <=  b + pB*x 
%           Ae*z == be + pE*x
%          Ath*x <= bth
%             lb <= z <= ub
%
% KKT conditions:
%         stanionarity: H*z + pF*x + f + Ga'*La = 0
%     compl. slackness: Aa*z - ba - pBa*x = 0
%   primal feasibility: An*z - bn - pBn*x < 0
%                       Ae*z - be - pE*x  = 0
%     dual feasibility: La > 0
%
% where Aa, ba, pBa are matrices formed by taking rows indexed by A from
% the corresponding matrix; An, bn, pBn contain only the inactive rows.
%
% To certify that A is an optimal active set, we solve an LP:
%
%    max  t
%    s.t. H*z + pF*x + f + Ga'*La  =  0  (optimality)
%                     Aa*z - pBa*x = ba (complementarity slackness)
%                     Ae*z -  pE*x = be (primal feasibility, equalities)
%                An*z - pBn*x + t <= bn  (primal feasibility, inequalities)
%                              La >= t   (dual feasibility)
%
% * if the LP is feasible with t>0, the active set is feasible and optimal
% * if the LP is feasible with t=0, the active set is degenerate
% * if the LP is feasible without the optimality constraints, the active
%   set is feasible but not optimal (not checked if card(A)=nz)
% * otherwise the active set is infeasible
% * t>0 is checked by t>=-MPTOPTIONS.zero_tol
%
% Before solving the LP we first check whether A(A, :) has full row rank.
% If not, we exit quickly.
%
% Inputs:
%   pqp: matrices of the pQP problem as an Opt object
%     A: active set to investigate (=indices of active constraints)
%
% Outputs:
%   result: flag indicating status of the active set
%      2: optimal, no LICQ violation
%      1: optimal, LICQ violated
%      0: feasible, but not optimal
%     -1: infeasible
%     -2: rank defficient
%     -3: undecided
%   nlps: number of LPs solved

global MPTOPTIONS

nlps = 0;
Ga = pqp.A(A, :);
% check rank of Ga first
rGa = rank(Ga'*Ga);
if rGa < length(A)
    % Ga is rank deficient
    result = -2;
    return
end

% determine the index set of inactive constraints
all = 1:pqp.m;
%N = setdiff(1:pqp.ni, A);
N = all(~ismembc(all, A)); % much faster version of setdiff for sorted arrays

Gn = pqp.A(N, :);
Sa = pqp.pB(A, :);
Sn = pqp.pB(N, :);
wa = pqp.b(A, :);
wn = pqp.b(N, :);
nA = length(A);
nN = length(N);

% optimization variables: [t; z; x; La]

% max t
lp.f = [-1 zeros(1, pqp.n+pqp.d+nA)];

% equality constraints:
%   H*z + pF*x + f + Ga'*La =  0  (optimality)
%               Ga*z - Sa*x = wa  (complementarity slackness)
%               Ge*z - Se*x = we  (primal feasibility, equalities)
lp.Ae = [ zeros(pqp.n, 1), pqp.H, pqp.pF, Ga'; ...
    zeros(nA, 1), Ga, -Sa, zeros(nA); ...
    zeros(pqp.me, 1), pqp.Ae, -pqp.pE, zeros(pqp.me, nA)];
lp.be = [ -pqp.f; wa; pqp.be ];

% inequality constraints:
%   Gn*z - Sn*x + t  <= wn  (primal feasibility, inequalities)
%                 La >= t   (dual feasibility)
%              Ath*x <= bth
nb = length(pqp.bth);
lp.A = [ ones(nN, 1), Gn, -Sn, zeros(nN, nA); ...
    ones(nA, 1), zeros(nA, pqp.n), zeros(nA, pqp.d), -eye(nA); ...
    zeros(nb, 1+pqp.n), pqp.Ath, zeros(nb, nA)];
lp.b = [ wn; zeros(nA, 1); pqp.bth];

% lower/upper bounds on [t; z; x; La]
% (includes lb <= z <= ub)
lp.lb = [-Inf; pqp.lb; -Inf(pqp.d, 1); zeros(nA, 1)];
lp.ub = [Inf; pqp.ub; Inf(pqp.d, 1); Inf(nA, 1)];

% avoid sanity checks in mpt_solve()
lp.quicklp = true;

nlps = nlps + 1;
sol = mpt_solve(lp);
if isequal(sol.how, 'ok')
    if sol.xopt(1) > MPTOPTIONS.rel_tol
        % feasible, optimal, LICQ holds
        result = 2;
    elseif sol.xopt(1) > -MPTOPTIONS.zero_tol
        % feasible, optimal, LICQ does not hold
        result = 1;
    else
        % undecided
        result = -3;
    end
else
    % undecided
    result = -3;
end

if (result==-3 || result==-1) && numel(A)<pqp.n
    % solve the LP without optimality conditions (not necessary if we are
    % on the last level)
    lp.Ae = lp.Ae(pqp.n+1:end, :);
    lp.be = lp.be(pqp.n+1:end);
    nlps = nlps + 1;
    sol = mpt_solve(lp);
    if isequal(sol.how, 'ok') && sol.xopt(1)>-MPTOPTIONS.zero_tol
        % feasible, but not optimal
        result = 0;
        
        if false
            % EXPERIMENTAL CODE
            %
            % how far away are we from optimality?
            q = 0;
            z=sdpvar(pqp.nz, 1);
            x=sdpvar(pqp.nx, 1);
            La=sdpvar(nA, 1);
            t=sdpvar(1, 1);
            e=sdpvar(1, 1);
            
            % min e - q*t
            %
            % -e <= H*z + Ga'*La <= e (weak optimality)
            % Ga*z - Sa*x - wa =   0  (complementarity slackness)
            % Gn*z - Sn*x + t <= wn   (primal feasibility)
            % La >= t                 (dual feasibility)
            % t <= 1
            F = [ -e <= pqp.H*z+Ga'*La <= e; ...
                Ga*z - Sa*x - wa == 0; ...
                Gn*z - Sn*x + t <= wn; ...
                La >= t; ...
                0 <= t <= 1; e >= 0 ];
            obj = e-q*t;
            info = solvesdp(F, obj, sdpsettings('verbose', 0));
            z=double(z);
            x=double(x);
            La=double(La);
            t=double(t);
            e=double(e);
            if e>500
                result = -1;
            end
            %OPTGAP{end+1} = struct('A', A, 'e', e, 't', t);
        end
    else
        % infeasible
        result = -1;
    end
end

end
