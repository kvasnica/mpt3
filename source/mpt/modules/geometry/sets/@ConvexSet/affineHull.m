function aff = affineHull(obj)
% Compute an implicitly-defined affine hull of the set
%
% On return:
%  aff * [x;1] = 0 defines the affine set
%
%  aff = [] if obj is empty
%
% Note : The affine hull function for general convex sets will only
% function for bounded sets. If you want the affine hull of an
% unbounded set, then intersect your set with a large
% full-dimensional box.

global MPTOPTIONS

if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

if numel(obj)>1
    aff = cell(size(obj));
    for i=1:numel(obj)
        aff{i} = obj(i).affineHull;
    end
    return;
end

% prepare output
aff = [];
if obj.isEmptySet
    return;
end

test  = eye(obj.Dim);
V = []; % Vertex discovered so far
while size(test,2) > 0
    % Choose a test direction in the null space of the basis
    t = test(:,1); test(:,1) = [];
    
    pos = obj.extreme(t);
    neg = obj.extreme(-t);
            
    if pos.exitflag == MPTOPTIONS.INFEASIBLE || pos.exitflag == MPTOPTIONS.ERROR || ...
            neg.exitflag == MPTOPTIONS.INFEASIBLE || neg.exitflag == MPTOPTIONS.ERROR
        error('Infeasible solution returned in non-empty set')
    end
    
    if pos.exitflag == MPTOPTIONS.UNBOUNDED || neg.exitflag == MPTOPTIONS.UNBOUNDED
        error('Can only compute the affine hull of bounded ConvexSets');
    end
    
    gap = pos.supp + neg.supp;
    if gap > MPTOPTIONS.abs_tol % This is a full-dimensional direction
        V = [V;pos.x';neg.x'];
        test = null(V(2:end,:)-ones(size(V,1)-1,1)*V(1,:));
    end
end

if ~isempty(V)
    n = null(V(2:end,:)-ones(size(V,1)-1,1)*V(1,:))';
    aff = [n n*V(1,:)'];
end

end