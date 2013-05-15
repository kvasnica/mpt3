function STdata = constructST(obj)
% Computes a search-tree for a given explicit solution
%
% STdata = constructST(obj)
%
% ---------------------------------------------------------------------------
% DESCRIPTION
% ---------------------------------------------------------------------------
% Computes a search-tree for a given explicit solution according to the algorithm
% proposed by Tondel, Johansen and Bemporad (see literature)
%
% ---------------------------------------------------------------------------
% INPUT
% ---------------------------------------------------------------------------
% obj             - Explicit controller
%
% ---------------------------------------------------------------------------
% OUTPUT                                                                                                    
% ---------------------------------------------------------------------------
% STdata.tree    - The search tree stored as matrix where each row consists of
%                 the elements Hi Ki c1 c2 which have the following meaning:
%         Hi Ki - Definition of the actual hyperplane, where the tree is branched
%         c1 c2 - if positive: Numbers of the rows of searchTree, where the two
%                 child nodes can be found.
%                 if negative: Negative numbers of the control laws, active in 
%                 the two child nodes, which are leaf nodes of the tree
% STdata.HK     - rounded and unique stack of hyperplanes
% STdata.max_depth  - depth of the tree
% STdata.n_total   - 
% STData.leafs     -
% STdata.holeHP    -
%
%
% ---------------------------------------------------------------------------
% LITERATURE
% ---------------------------------------------------------------------------
% "Evaluation of piecewise affine control via binary search tree"; P. Tondel, 
% T. A. Johansen and A. Bemporad; Automatica, Vol. 39, No. 5, pp. 945-950
%

% Copyright is with the following author(s):
%
% (C) 2005 Michal Kvasnica, Automatic Control Laboratory, ETH Zurich,
%          kvasnica@control.ee.ethz.ch
% (C) 2004 Arne Linder, Faculty of Electrical, Information and Media Engineering, 
%          Wuppertal University, alinder@uni-wuppertal.de


% TODO:
%   - we want to know the volume of each hole
%     (keep a list of hole-creating hyperplanes)
%   - include an option to keep the open-loop solution (i.e. Fi, Gi not
%   stripped down to (1:nu)

global MPTOPTIONS

if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

Options = MPTOPTIONS.modules.ui.EMPCSTController;


% extract feedback law as PolyUnion object
U = obj.feedback;

if ~isa(U,'PolyUnion')
    error('Input argument must be a PolyUnion object!');
end

holeHP = {};
allHPs = [];

nR = U.Num;
nx = obj.nx;
nu = obj.nu;

% detect redundant control laws and create a map "region index -> feedback
% index" in FGidx
FG = cell(1, nR);
FGidx = zeros(1, nR);
for i = 1:nR
    % extract affine control laws
    Fi=U.Set(i).getFunction('primal').F(1:nu,:);
    Gi=U.Set(i).getFunction('primal').g(1:nu);
    
    FG{i} = round([Fi Gi]*Options.roundcoef)/...
        Options.roundcoef;
end
for i = nR:-1:1
    a = cellfun(@(x) (isequal(x, FG{i})), FG, ...
        'UniformOutput', false);
    FGidx(find([a{:}])) = i;
end
fprintf('Found %d unique control laws (out of %d)\n', ...
    length(unique(FGidx)), length(FG));

% extract vertices
% fprintf('Computing extremal vertices of regions...\n');
E = {};

% extract hyperplanes
H = cell(1,nR);
K = cell(1,nR);
[H{:}] = deal(U.Set.A);
[K{:}] = deal(U.Set.b);

% HK-vertical stack
HKorig = cell(1, nR);
[HKorig{:}] = deal(U.Set.H);
HKorig = cat(1, HKorig{:});

% idx_r = [];
% for i = 1:nR
%     idx_r = [idx_r; i*ones(size(HKcell{i}, 1), 1)];
% end

% find linearly independent hyperplanes
HKorig = round(HKorig*Options.roundcoef)/Options.roundcoef;
HKorig = unique(HKorig, 'rows');
nHorig = size(HKorig, 1);
[a, b] = ismember(HKorig, -HKorig, 'rows');
idx1 = find(a==0);
idx2 = b(b > (1:length(b))');
HK = HKorig(unique([idx1; idx2]), :);
HK = sortrows(HK);
nH = size(HK, 1);
fprintf('Found %d unique hyperplanes (out of %d)\n', nH, nHorig);


Ileft = cell(nH, 1);
Iright = cell(nH, 1);
kickout = zeros(nH, 1);
Jk = [];
for i = 1:nH
    if mod(i, 20)==0 | i==1 | i == nH
        fprintf('determining position of regions vs. hyperplane #%d out of %d\n', i, nH);
    end
    [Ileft{i}, Iright{i}, kickout(i)] = sub_getleftright(E, H, K, HK, 1:nR, i, Jk, MPTOPTIONS.rel_tol, MPTOPTIONS.abs_tol);
end

% remove hyperplanes which are on the boundary of feasible set
nHorig = nH;
stay = find(kickout == 0);
HK = HK(stay, :);
Ileft = Ileft(stay);
Iright = Iright(stay);
nH = size(HK, 1);
fprintf('%d hyperplanes on boundaries removed\n', nHorig-nH);


ST = [];
leafs = {};
to_explore =  { 1:nR };
J_store = { [] };
HP_used = zeros(1, nH);
iter = 0;
st_idx = 1;
hole_cnt = 0;
max_depth = 0;
n_leafs = 0;
n_total = -1;
% FGidx = 1:length(FGidx);

while ~isempty(to_explore)
    
    iter = iter + 1;
    if mod(iter, 20)==0 || iter==1
        fprintf('iteration #%d, nodes to explore: %d\n', iter, length(to_explore));
    end
    
    regions = to_explore{1};
    to_explore = to_explore(2:end);
    Jk = J_store{1};
    J_store = J_store(2:end);
    
    
    IJk = regions;
    
    [L, R] = sub_modifyLR(Ileft, Iright, IJk, nR);
    
    % find the hyperplane which maximizes the number of separated regions
    cost = Inf*ones(1, nH);
    nleft = zeros(1, nH);
    nright = zeros(1, nH);
    for i = setdiff(1:nH, abs(Jk)),
        Fleft = unique(FGidx(L{i}));
        Fright = unique(FGidx(R{i}));
        nleft(i) = length(Fleft);
        nright(i) = length(Fright);
        cost(i) = max(nleft(i), nright(i));
    end
    cost(cost==0) = Inf;
    [a, b] = min(cost);
    
    % compute the exact Ip, In
    mincostpos = find(cost==a);
    cost2 = zeros(1, length(mincostpos));
    for i = 1:length(mincostpos)
        mincostHP = mincostpos(i);
        [L{mincostHP}, R{mincostHP}] = sub_getleftright(E, H, K, HK, IJk, ...
            mincostHP, Jk, MPTOPTIONS.rel_tol, MPTOPTIONS.abs_tol);
        
        Fleft = unique(FGidx(L{mincostHP}));
        Fright = unique(FGidx(R{mincostHP}));
        nleft(i) = length(Fleft);
        nright(i) = length(Fright);
        cost2(i) = max(nleft(i), nright(i));
    end
    cost2(cost2==0) = Inf;
    [a, b] = min(cost2);
    b = mincostpos(b);
    
    % secondary criterion -- number of separated regions
    mincostpos2 = find(cost2==a);
    cost3 = zeros(1, length(mincostpos2));
    for i = 1:length(mincostpos2)
        nleft = length(L{mincostpos(mincostpos2(i))});
        nright = length(R{mincostpos(mincostpos2(i))});
        cost3(i) = max(nleft, nright);
    end
    [a, b] = min(cost3);
    b = mincostpos(mincostpos2(b));
    
    if isinf(a)
        fprintf('No more progress...\n');
        break
    elseif a<=1
        a;
    end
    
    left_regions = L{b};
    right_regions = R{b};
    [left_F, bl] = unique(FGidx(left_regions));
    [right_F, br] = unique(FGidx(right_regions));
    
    fprintf('nodes: %d, N: %d, P: %d, Jk: %s Optimal HP: %d\n', ...
        length(to_explore), ...
        length(left_F), length(right_F), ...
        mat2str(Jk), b);
    
    %     searchtree_plothp(ctrl, HK, [-5 5], [-5 5], abs(Jk));
    
    
    if length(right_regions) == 0
        % infeasible on the right
        fprintf('Hole in the partition found!\n');
        hole_cnt = hole_cnt + 1;
        right_node = 0;
        max_depth = max(max_depth, length(Jk)+1);
        n_leafs = n_leafs+1;
        holeHP{end+1} = [Jk b];
        
    elseif length(right_F) == 1
        % leaf node
        right_node = -right_regions(1);
        leafs{end+1} = [-right_node Jk b];
        max_depth = max(max_depth, length(Jk)+1);
        n_leafs = n_leafs+1;
        
    else
        st_idx = st_idx + 1;
        right_node = st_idx;
        to_explore{end+1} = right_regions;
        J_store{end+1} = [Jk b];
        
    end
    
    if length(left_regions) == 0
        % infeasible on the left
        fprintf('Hole in the partition found!\n');
        hole_cnt = hole_cnt + 1;
        left_node = 0;
        max_depth = max(max_depth, length(Jk)+1);
        n_leafs = n_leafs+1;
        holeHP{end+1} = [Jk -b];
        
    elseif length(left_F) == 1
        % leaf node
        left_node = -left_regions(1);
        leafs{end+1} = [-left_node Jk -b];
        max_depth = max(max_depth, length(Jk)+1);
        n_leafs = n_leafs+1;
        
    else
        st_idx = st_idx + 1;
        left_node = st_idx;
        to_explore{end+1} = left_regions;
        J_store{end+1} = [Jk -b];
    end
    
    n_total = n_total + 2;
    
    % HK(b, :) is the best separating hyperplane
    ST = [ST; HK(b,:) right_node left_node];
    HP_used(b) = 1;
    
    
end

n_total = size(ST, 1)*2+1;
fprintf('Finished at iteration %d\n', iter);
fprintf('Depth: %d, total nodes: %d, leaf nodes: %d (%.1f %%)\n', ...
    max_depth, n_total, n_leafs, n_leafs/n_total*100);
% fprintf('Depth: %d, leaf nodes: %d\n', max_depth, n_leafs);

if hole_cnt > 0
    fprintf('\nFound %d holes in the partition!\n', hole_cnt);
end

STdata.tree = ST;
STdata.HK = HK;
STdata.max_depth = max_depth;
STdata.n_total = n_total;
STdata.leafs = leafs;
STdata.holeHP = holeHP;


end

% -------------------------------------------------------------------------
function [L, R] = sub_modifyLR(Ileft, Iright, regions, nR)

% this is a faster version of C=intersect(A, B):
%   Z = zeros(1, max(length(A), length(B)))
%   Az = Z;
%   Az(A) = 1;
%   Bz = Z;
%   Bz(B) = 1
%   C = find(A & B)

L = Ileft;
R = Iright;
Az = zeros(1, nR);
B = Az;
B(regions) = 1;

for i = 1:length(Ileft)
    % fast version:
    A = Az; A(Ileft{i}) = 1;
    L{i} = find(A & B);
    A = Az; A(Iright{i}) = 1;
    R{i} = find(A & B);
    % slower version using intersect():
    %     L{i} = intersect(Ileft{i}, regions);
    %     R{i} = intersect(Iright{i}, regions);
end

end

% -------------------------------------------------------------------------
function [ileft, iright, kickout] = sub_getleftright(E, H, K, HK, reg_idx, hp_idx, Jk, rel_tol, abs_tol)
% determines which regions lie on the negative (A*x <= b) and
% positive (A*x > b) side of a given hyperplane

if ~isempty(E)
    error('Checks based on extremal vertices not supported.');
end

nx = size(HK, 2)-1;
nJk = length(Jk);
HH = zeros(nJk, nx);
KK = zeros(nJk, 1);
for i = 1:nJk
    if Jk(i) < 0
        HH(i, :) = HK(-Jk(i), 1:nx);
        KK(i) = HK(-Jk(i), end);
    else
        HH(i, :) = -HK(Jk(i), 1:nx);
        KK(i) = -HK(Jk(i), end);
    end
end

nP = length(reg_idx);
ileft = zeros(1, nP);
iright = zeros(1, nP);
for i = reg_idx
    
    if isempty(E) || isempty(E{i})
        % check by solving an LP
        Hn = [HH; H{i}; HK(hp_idx, 1:nx)];
        Kn = [KK; K{i}; HK(hp_idx, end)];
        %R = sub_chebyball(Hn, Kn, nx, rel_tol, abs_tol, lpsolver);
        R=Polyhedron(Hn,Kn).chebyCenter.r;
        if R > abs_tol
            ileft(i) = 1;
        end
        
        Hn = [HH; H{i}; -HK(hp_idx, 1:nx)];
        Kn = [KK; K{i}; -HK(hp_idx, end)];
        %R = sub_chebyball(Hn, Kn, nx, rel_tol, abs_tol, lpsolver);
        R=Polyhedron(Hn,Kn).chebyCenter.r;
        if R > abs_tol
            iright(i) = 1;
        end
        
    else
        % check using extremal vertices
        V = E{i};
        nV = size(V, 1);
        %         ok = zeros(1, nV);
        %         Hn = [HH; HK(hp_idx, 1:nx)];
        %         Kn = [KK; HK(hp_idx, end)];
        %         for j = 1:nV
        %             ok(j) = all(Hn*V(j, :)' - Kn < -abs_tol);
        %         end
        %         ileft(i) = any(ok);
        %
        %         ok = zeros(1, nV);
        %         Hn = [HH; -HK(hp_idx, 1:nx)];
        %         Kn = [KK; -HK(hp_idx, end)];
        %         for j = 1:nV
        %             ok(j) = all(Hn*V(j, :)' - Kn < -abs_tol);
        %         end
        %         iright(i) = any(ok);
        
        Hn = [HH; HK(hp_idx, 1:nx)];
        Kn = [KK; HK(hp_idx, end)];
        ileft(i) = any(all((Hn*V' - repmat(Kn, 1, nV)) <= -abs_tol, 1));
        Hn = [HH; -HK(hp_idx, 1:nx)];
        Kn = [KK; -HK(hp_idx, end)];
        iright(i) = any(all((Hn*V' - repmat(Kn, 1, nV)) <= -abs_tol, 1));
    end
end

ileft = find(ileft);
iright = find(iright);
kickout = max([length(ileft) length(iright)]) == nP && ...
    min([length(ileft) length(iright)]) == 0;

end

% -------------------------------------------------------------------------
% function R=sub_chebyball(H,K,nx,rel_tol,abs_tol,lpsolver)
%
% if all(K>-1e9),
%     % use 'rescue' function - resolve an LP automatically if it is infeasible
%     % with default solver
%     [xopt,fval,lambda,exitflag,how]=mpt_solveLPs([zeros(1,nx) 1],[H, -sqrt(sum(H.*H,2))],...
%         K,[],[],[],lpsolver);
% else
%     how = 'infeasible';
% end
%
% if ~strcmp(how,'ok')
%     % maybe there is a numerical problem, thus we normalize H and K
%
%     [nc,nx]=size(H);
%     Anorm=sqrt(sum(H .* H,2));
%     ii=find(Anorm<=abs_tol | Anorm<=abs(rel_tol*K));
%     nii=length(ii);
%     if nii>0
%         Anorm(ii)=1;
%         H(ii,:)=repmat([1 zeros(1,nx-1)],nii,1);
%         % decide if some constraint is always true
%         jj=(K(ii)>=-abs_tol);
%         K(ii(jj))=Inf;
%         % or is it always false
%         K(ii(~jj))=-Inf;
%     end
%     temp=1./Anorm;
%     %S%H=H .* repmat(temp,1,nx);
%     H=H .* temp(:,ones(1,nx));
%     K=K .* temp;
%
%     % If any boundary is -Inf polytope P is empty
%     %--------------------------------------------
%     if any(K==-Inf)
%         xc=zeros(nx,1);
%         R=-Inf;
%         lambda=zeros(nc,1);
%         return;
%     end
%
%     % Remove rows with Inf boundaries
%     %--------------------------------
%     ii=(K==Inf);
%     H(ii,:)=[];
%     K(ii)=[];
%
%     if size(H,1)==0
%         xc=zeros(nx,1);
%         R=Inf;
%         lambda=zeros(nc,1);
%         return;
%     end
%
%     x0 = [zeros(nx,1); 1000];         % hard-coded initial conditions
%
%     % use 'rescue' function - resolve an LP automatically if it is infeasible
%     % with default solver
%     [xopt,fval,lambda,exitflag,how]=mpt_solveLPs([zeros(1,nx) 1],[H, -sqrt(sum(H.*H,2))],K,[],[],x0,lpsolver);
% end
%
% R=-xopt(nx+1); % Radius of the ball
%
%
%
% return
%
% clear
% Double_Integrator
% probStruct.N = 8;
% ctrl = mpt_control(sysStruct, probStruct);
%
%
% cs = struct(ctrl);
% for i = 1:length(cs.Gi)
%     cs.Gi{i} = i*ones(size(cs.Gi{i}));
%     cs.Fi{i} = i*ones(size(cs.Fi{i}));
% end
% ctrl2 = mptctrl(cs);
%
% st = searchtree_new(ctrl);
% stn = mpt_searchTree(ctrl2);
%
% X0 = mpt_feasibleStates(ctrl);
% U = [];
% for i = 1:size(X0, 1)
%     ust = st(X0(i, :)');
%     uopt = ctrl(X0(i, :)');
%     U = [U; ust uopt];
% end
% [a, b] = max(abs(U(:, 1) - U(:, 2)))
%
% R = [];
% for i = 1:size(X0, 1)
%     x0 = X0(i, :)';
%     rst = searchtree_eval(st.details.searchTree, x0);
%     rstn = searchtree_eval(stn.details.searchTree, x0);
%     R = [R; rst rstn];
% end
% [a, b] = max(abs(R(:, 1) - R(:, 2)))
% [size(st.details.searchTree, 1) size(stn.details.searchTree, 1)]

