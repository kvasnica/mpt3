function [index, details] = find_region(x,Parray,graph, index, details)
%
% For given point x, find a region index from the partition Parray of the
% explicit solution where the point lies.
%
% input:
%   x - value of parameter
%   Parray - an array of regions 
%   graph - represented by adjacency list
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS=mptopt;
end

DEBUG=0;

if nargin<4
    index = 1;
    details.niter = 0;
    details.noper = 0;
    details.multiplications = 0;
    details.summations = 0;
    details.comparisons = 0;
end
if nargin<5
    details.niter = 0;
    details.noper = 0;
    details.multiplications = 0;
    details.summations = 0;
    details.comparisons = 0;
end

details.niter = details.niter + 1;

% extract polyhedron
P = Parray(index);

if DEBUG
    if index<=1
        plot(Parray); 
        hold on;
        text(x(1),x(2),'x');
    end
    xc = chebyCenter(P);
    text(xc.x(1),xc.x(2),num2str(index));
end  

% get direction
%P.normalize; % polytopes are normalized when returned from PLCP solver
d = P.A*x - P.b; % compute distance
direction = d > MPTOPTIONS.abs_tol;
pd = find(direction);

% count operations
n=P.Dim;
nv = size(P.H,1);
details.multiplications = details.multiplications + nv*n;
details.summations = details.summations + nv*n;
details.comparisons = details.comparisons + nv;
details.noper = details.multiplications + details.summations + details.comparisons;

if any(direction)
    % pick the direction with maximum distance over positive d
    [~,id]= max(d(pd));
    direction = false(size(direction));
    direction(pd(id))=true;
    
    % add comparisons
    details.comparisons = details.comparisons + numel(pd)-1;
    details.noper = details.multiplications + details.summations + details.comparisons;
    
    % next region to check
    index_new = graph{index}(direction);
    if length(index_new)>1
        % if there are more ways, pick the one which is not empty
        v = cellfun(@isempty,index_new);
        index_new = index_new(~v);
        if isempty(index_new)
            % point out of feasible area
            index = [];
            return;
        end
    end

    % if there are more choices, pick first    
    index_new=index_new{1};
    if numel(index_new)>1
        % if the facet neighbors to more regions, pick the first
        index_new=index_new(1);
    end
    
    if isempty(index_new)
        % point out of feasible area
        index = [];
    else
        % if x does not lie in this region, continue
        [index,details] = find_region(x,Parray,graph, index_new, details);
    end
    
end

end