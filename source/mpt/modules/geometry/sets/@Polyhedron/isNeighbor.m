function [ts, iP, iQ] = isNeighbor(P,Q,fP,fQ)
%
% test if regions P are Q neighbors along the given facets
%
% inputs: regions P, Q
%         fP, fQ - (optional) indices of the facets to test
% outputs: ts - return status if P and Q are adjacent or not
%          iP - index of a facet of region P that is neighbor to iQ
%          iQ - index of a facet of region Q that is neighbor to iP
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
   MPTOPTIONS = mptopt;
end

error(nargchk(2,4,nargin));

validate_polyhedron(Q);

if numel(P)>1 || numel(Q)>1
    error('P and Q must have the length of 1.');
end

if P.Dim ~= Q.Dim
    error('Polyhedra must be in the same dimension.');
end

% initial values to be returned if neighborhood is not proven
ts = false;
iP = [];
iQ = [];

% empty P,Q -> return 0
if isEmptySet(P) || isEmptySet(Q)
    if MPTOPTIONS.verbose>=1 
        disp('P or Q is empty.');
    end
    return
end

% make P, Q irredundant
P.minHRep();
Q.minHRep();

% check indices of the facets if provided
if nargin>2
    if ~isempty(fP)
        validate_indexset(fP);
        % convert logical index sets to numeric
        if islogical(fP) || any(fP==0)
            fP = find(fP);
        end
        % consider only unique indices
        fP = unique(fP);
        
        n1 = size(P.H,1);
        if numel(fP)>n1 || any(fP>n1)
            error('Facet index set for region P contains indices out of range.');
        end
        
        % must be rows
        if size(fP,1)>size(fP,2)
            fP = fP';
        end
    end
else
    fP = [];
end
if nargin>3
    if ~isempty(fQ)
        validate_indexset(fQ);
        % convert logical index sets to numeric
        if islogical(fQ) || any(fQ==0)
            fQ = find(fQ);
        end
        % consider only unique indices
        fQ = unique(fQ);
        n2 = size(Q.H,1);
        if numel(fQ)>n2 || any(fQ>n2)
            error('Facet index set for region Q contains indices out of range.');
        end

        % must be rows
        if size(fQ,1)>size(fQ,2)
            fQ = fQ';
        end
    end
else
    fQ = [];
end



% find the facets that are the closest
r = distance(P,Q);
if isempty(fP) || isempty(fQ)
    % if the distance is less that tolerance-> P, Q are neigbors
    if r.exitflag==MPTOPTIONS.OK
         % This rather high value of tolerance is due to possible solver
         % problems when computing distance
        if r.dist<0.1
            if isempty(fP)
                fP = find(P.A*r.x > P.b-MPTOPTIONS.rel_tol)';
            end
            if isempty(fQ)
                fQ = find(Q.A*r.y > Q.b-MPTOPTIONS.rel_tol)';
            end
        end
    end
end


%now check which facets from those found in the first hit are neighbors
for i=fP
    % find a center point of the facet i
    xP = P.chebyCenter(i);

    % a small step beyond the facet
    gp = P.H(i,1:end-1);
    ngp = norm(gp);
    if ngp>MPTOPTIONS.abs_tol && xP.exitflag==MPTOPTIONS.OK
        thp = xP.x + 1.2/ngp*gp'*MPTOPTIONS.region_tol;
        
        % check if thp lies inside Q
        isinQ = Q.contains(thp);
        if isinQ
            iP = i;
            
            % neigborhood must hold also from Q to P
            for j=fQ
                % find a center point of the facet i
                xQ = Q.chebyCenter(j);
                
                % a small step beyond the facet
                gq = Q.H(j,1:end-1);
                ngq = norm(gq);
                if ngq>MPTOPTIONS.abs_tol && xQ.exitflag==MPTOPTIONS.OK
                    thq = xQ.x + 1.2/ngq*gq'*MPTOPTIONS.region_tol;
                    
                    % check if thq lies inside P
                    isinP = P.contains(thq);
                    if isinP
                        ts = true;
                        iQ = j;
                    end
                end
            end
        end
    end
end


end

